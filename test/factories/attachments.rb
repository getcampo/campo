FactoryBot.define do
  factory :attachment do
    user
    file { Rack::Test::UploadedFile.new(Rails.root.join('test/fixtures/files/logo.png'), 'image/png') }
  end
end
