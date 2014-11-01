class Lecture
  BUCKET = "ada-lectures"
  attr_accessor :name, :description, :date, :link, :url, :key

  def initialize(key, url, attrs={})
    @key         = key
    @url         = url
    @name        = attrs["name"]
    @description = attrs["description"]
    @link        = attrs["link"]
    @date        = Date.parse(attrs["date"]) if attrs["date"]
  end

  def url(format=nil)
    format ? @url.sub(/m[p4][v4]\z/i, format.to_s) : @url
  end

  def self.find(key)
    create(bucket.objects[key])
  end

  def self.all
    @files ||= begin
      f = files.map do |file|
        create(file)
      end
      f.sort_by(&:date).reverse
    end
  end

  def self.create(file)
    self.new(file.key, file.public_url.to_s, file.metadata.to_h)
  end

  def self.files
    bucket.objects.select {|obj| obj.key.match(/m4v/i) }
  end

  def self.bucket
    AWS::S3::Bucket.new(BUCKET)
  end

  def self.client
    @client ||= AWS::S3::Reso.new
  end
end
