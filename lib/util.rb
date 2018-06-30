module Util
  @status_code = nil
  def get_param(param_name, required = true, default = nil, status_code = 400)
    value = params[param_name]
    if required && !value
        @status_code = status_code
        raise "Parameter #{param_name} is required"
    end
    value = default if value == nil
    return value
  end
end