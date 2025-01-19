{ ... }:
let
  commands = [
    {
      # Highlight when yanking (copying) text
      event = "TextYankPost";
      group = "my-highlight-yank";
      callback = {
        __raw =
          # lua
          ''
            function()
              vim.highlight.on_yank({higroup="Visual", timeout=200})
            end
          '';
      };
    }
  ];

  processedCommands =
    builtins.mapAttrs (_: values: (builtins.map (value: builtins.removeAttrs value [ "type" ]) values))
      (
        builtins.groupBy (command: command.type) (
          builtins.concatMap (
            command:
            let
              group = command.group;
            in
            [
              {
                type = "group";
                name = group;
                value = {
                  clear = true;
                };
              }

              (
                {
                  type = "command";
                }
                // command
              )
            ]
          ) commands
        )
      );
in
{
  programs.nixvim = {
    autoGroups = builtins.listToAttrs (processedCommands.group);
    autoCmd = processedCommands.command;
  };
}
