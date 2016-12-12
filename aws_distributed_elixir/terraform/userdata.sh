#!/bin/bash -v
apt-get update -y

PUBLIC_HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/public-hostname)
IEX_NAME="aws@$PUBLIC_HOSTNAME"

echo -e "defmodule Hello do
  def world do
    IO.puts \"Hello world from $IEX_NAME\"
    IO.puts \"My connections: <#{connections(Node.list)}> said to say hello for them.\"
  end

  defp connections([]),   do: \"none\"
  defp connections(list), do: Enum.join(list, \", \")
end"  >> /home/ubuntu/hello.exs

chmod +x /home/ubuntu/hello.exs
