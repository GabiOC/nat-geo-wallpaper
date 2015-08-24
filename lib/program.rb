require_relative '../bin/environment.rb'

class ImageOfTheDay

  def scrape
    f = open('http://photography.nationalgeographic.com/photo-of-the-day/')
    doc = Nokogiri::HTML(f)

    url = doc.css(".primary_photo a img").attr("src").value.prepend("http:")
    delete_old_image
    save_image(url)
    set_wallpaper
  end

  def delete_old_image
    FileUtils.rm_rf(Dir.glob("tmp/image.jpg")) unless File.exist? "tmp/image.jpg"
  end

  def save_image(url)
    image = MiniMagick::Image.open(url)
    image.write("tmp/image.jpg")
  end

  def set_wallpaper
    path = File.absolute_path("tmp/image.jpg")
    cmd = "sqlite3 ~/Library/Application\\ Support/Dock/desktoppicture.db \"update data set value = '#{path}'\" && killall Dock"
    `#{cmd}`
  end
end
