# Building images

```
aws-vault exec personal -- make
```

# Instance image heirarchy

- `base`
    Base system image.

    - `bastion`
        Image for a bastion instance that provides entry and NAT.

    - `client`
        Image for generic nodes, runs Nomad natively in client mode.

        - `server`
            Image for server infrastructure, runs Nomad and Consul services natively on the Instance in server mode.
