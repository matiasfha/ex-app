Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '324006000982228', '739e9a262d2101043b0afe9a8d266733'
  provider :twitter, 'AG8uAgQCV15AbjPc9cRlYQ', 'velTM3lvxgttbSWXjSzRaiIDGnc9GNTcmda9BAJM'
end