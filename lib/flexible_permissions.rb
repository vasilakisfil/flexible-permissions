require "flexible_permissions/version"
require "flexible_permissions/modules"
require "flexible_permissions/base"

if defined?(Pundit)
  require "flexible_permissions/pundit"
end
