{ config, ... }:

{
  # Add interactive user to the hermes group for CLI access
  users.users.williamwhds.extraGroups = [ "hermes" ];

  services.hermes-agent = {
    enable = true;

    # Use DeepSeek directly (OpenAI-compatible API)
    settings.model = {
      base_url = "https://api.deepseek.com";
      default = "deepseek-chat";
    };

    # Reference the sops-encrypted env file
    environmentFiles = [ config.sops.secrets."hermes-env".path ];

    # Add the CLI to your PATH and share state
    addToSystemPackages = true;
  };
}
