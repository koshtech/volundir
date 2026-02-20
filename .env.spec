### begin Volundir Base

# Default backend to ruby
BACKEND=ruby

# Executor bin
# Can include:
#   Complete path such as /bin/ruby;
#   A value from external command like `which ruby`;
#   Or use system defaults, calling just ruby.
EXECUTOR=ruby

# Binding HTTP port
PORT=3020

# In development, we can use localhost, 127.0.0.1 or 0.0.0.0
# In production, never use public IPs.
# Recommended bind IPs are 127.0.0.1 and internal network addresses
BIND_IPS=localhost

### end Volundir Base
