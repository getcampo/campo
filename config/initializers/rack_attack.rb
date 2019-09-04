class Rack::Attack
  throttle('req/ip', limit: 300, period: 5.minutes) do |req|
    req.ip
  end

  throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
    if req.path == '/session' && req.post?
      req.ip
    end
  end

  throttle("logins/account", limit: 5, period: 20.seconds) do |req|
    if req.path == '/session' && req.post?
      req.params['login'].presence
    end
  end
end
