let
  desheffer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK78PLljlhmLf8HSyRqc97MSHxlXx3rqkY0uPG81iThH";
  users = [ desheffer ];

  argent = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBcsCrdHED/c/hKwIMSIesma4n8+vC6pvRzM8+vUAwOh";
  nixos-vm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBx6IjVdCOt+2w3E/nq3RWguMLbvetX1Bva2Zx7heFL0";
  systems = [ argent nixos-vm ];
in {
}
