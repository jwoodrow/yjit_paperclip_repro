FactoryBot.define do
  factory :image do
    attachment_file_size { 1_000 }
    attachment_updated_at { Time.current }

    attachment { Rack::Test::UploadedFile.new(Rails.root.join('db', 'fixtures', 'test_image.png'), 'image/png') }
  end
end
  