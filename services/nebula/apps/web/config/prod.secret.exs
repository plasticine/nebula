use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :web, Nebula.Web.Endpoint,
  secret_key_base: "jX1SsYGb0uYaAFs74bSdiDcAVbFm58O5Tg16nMUEMVzEkgzcOxENcoWrSMhYUdl8"

config :exsentry,
  dsn: System.get_env("API_SENTRY_DSN")
