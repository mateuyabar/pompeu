module Pompeu
  AndroidString = Struct.new(:key, :text, :translatable)

  class AndroidFile
    attr_reader :strings, :target

    def initialize(target, strings = [])
      @target = target
      @strings = strings
    end

    def self.from_files file_path, target
      File.open(file_path) {|f| from_xml(f, target)}
    end

    # loads data from strings xml
    def self.from_xml input, target
      strings = []
      doc = Nokogiri::XML(input)
      string_lines = doc.xpath("//string")
      string_lines.each do |string_line|
        key = string_line["name"]
        translatable = string_line["translatable"] != "false"
        text = unescape(string_line.children.text)
        strings << AndroidString.new(key, text, translatable)
      end
      AndroidFile.new target, strings
    end

    # data to string.xml format
    def to_xml
      builder = Nokogiri::XML::Builder.new(:encoding => 'utf-8') do |xml|
        xml.resources {
          @strings.each do |android_string|
            if android_string.translatable
              xml.string(name: android_string.key) {
                puts android_string if !android_string.text
                xml.text escape(android_string.text)
              }
            else
              xml.string(name: android_string.key, translatable: false) {
                xml.text escape(android_string.text)
              }
            end
          end
        }
      end
      builder.to_xml(indent: 4)
    end

    def to_files file
      File.write(file, to_xml)
    end

    def to_db textDB, lang
      @strings.each do |android_string|
        textDB.add_translation @target, android_string.key, lang, android_string.text, TranslationConfidence::UNKNOWN, android_string.translatable
      end
    end

    def self.from_db textDB, lang, target
      strings = []
      textDB.texts_for_target(target).each do |pompeu_text|
        translation = pompeu_text.translation(lang)
        if pompeu_text.translation lang
          key = pompeu_text.key_for target
          text = pompeu_text.translation(lang).text
          translatable = pompeu_text.translatable
          strings << AndroidString.new(key, text, translatable)
        end
      end
      AndroidFile.new target, strings
    end

    def self.unescape string
      string.gsub("\\'", "'")
    end

    def escape string
      string.gsub("'", "\\\\'")
    end

    def ==(other_object)
      @strings.sort_by {|x| x.key} == other_object.strings.sort_by {|x| x.key}
    end
  end
end