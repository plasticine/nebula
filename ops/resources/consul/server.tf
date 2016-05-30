resource "aws_iam_role" "consul" {
  lifecycle { create_before_destroy = true }

  name = "consul"
  path = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {"AWS": "*"},
        "Effect": "Allow",
        "Sid": ""
      }
  ]
}
EOF
}

resource "aws_iam_role_policy" "consul" {
  lifecycle { create_before_destroy = true }

  name = "consul"
  role = "${aws_iam_role.consul.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:Describe*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "elasticloadbalancing:Describe*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:ListMetrics",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:Describe*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "autoscaling:Describe*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "consul" {
  lifecycle { create_before_destroy = true }

  name = "consul"
  roles = ["${aws_iam_role.consul.name}"]
}

resource "template_file" "server" {
  lifecycle { create_before_destroy = true }

  template = "${file("${path.module}/resources/user_data.bash.template")}"

  vars {
    aws_region = "${var.region}"
    provisioning_bucket_id = "${var.provisioning_bucket_id}"
    server_count = "${var.server_count}"
    recursor = "${var.recursor}"
  }
}

resource "aws_launch_configuration" "consul" {
  lifecycle { create_before_destroy = true }

  image_id = "${var.ami}"
  instance_type = "${var.server_instance_type}"
  user_data = "${template_file.server.rendered}"
  security_groups = ["${split(",", var.security_groups)}"]
  iam_instance_profile = "${aws_iam_instance_profile.consul.id}"
  key_name = "${var.key_name}"
}

# References:
# - https://github.com/hashicorp/terraform/issues/1552#issuecomment-190864512
# - http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-as-group.html
resource "aws_cloudformation_stack" "autoscaling_group" {
  name = "consul"
  template_body = <<EOF
{
  "Resources": {
    "Consul": {
      "Type": "AWS::AutoScaling::AutoScalingGroup",
      "Properties": {
        "AvailabilityZones": ["ap-southeast-2a"],
        "LaunchConfigurationName": "${aws_launch_configuration.consul.name}",
        "MaxSize": "5",
        "DesiredCapacity": "3",
        "MinSize": "2",
        "TerminationPolicies": ["OldestLaunchConfiguration", "OldestInstance"],
        "VPCZoneIdentifier": ["${var.subnet_id}"],
        "Tags": [
          {
            "Key": "role",
            "Value": "consul",
            "PropagateAtLaunch": true
          },
          {
            "Key": "Name",
            "Value": "Consul",
            "PropagateAtLaunch": true
          }
        ]
      },
      "UpdatePolicy": {
        "AutoScalingRollingUpdate": {
          "MinInstancesInService": "2",
          "MaxBatchSize": "1",
          "PauseTime": "PT10m"
        }
      }
    }
  },
  "Outputs": {
    "AsgName": {
      "Description": "The name of the auto scaling group",
       "Value": {"Ref": "Consul"}
    }
  }
}
EOF
}
