module ApplicationHelper
  def responsive_asset_picture(
    source,
    alt:,
    sizes: nil,
    width: nil,
    height: nil,
    srcset: nil,
    sources: [],
    picture_class: nil,
    img_class: nil,
    aspect_ratio: nil,
    fit: "cover",
    loading: "lazy",
    decoding: "async",
    fetchpriority: nil
  )
    picture_classes = ["orar-imagem", picture_class]
    picture_classes << "orar-imagem--proporcao" if aspect_ratio.present?

    picture_options = {}
    picture_options[:class] = picture_classes.compact.join(" ")
    picture_options[:style] = "--orar-aspect-ratio: #{aspect_ratio};" if aspect_ratio.present?

    image_options = {
      alt: alt,
      width: width,
      height: height,
      sizes: sizes,
      class: ["orar-imagem__img", img_class].compact.join(" "),
      loading: loading,
      decoding: decoding
    }
    image_options[:srcset] = build_asset_srcset(srcset) if srcset.present?
    image_options[:fetchpriority] = fetchpriority if fetchpriority.present?
    image_options[:style] = "--orar-image-fit: #{fit};" if fit.present?

    content_tag(:picture, **picture_options) do
      safe_join(
        build_picture_sources(sources) + [image_tag(source, **image_options)]
      )
    end
  end

  private

  def build_picture_sources(sources)
    Array(sources).filter_map do |source|
      next if source.blank?

      options = {}
      options[:media] = source[:media] if source[:media].present?
      options[:type] = source[:type] if source[:type].present?
      options[:sizes] = source[:sizes] if source[:sizes].present?

      srcset_value = build_asset_srcset(source[:srcset] || source[:source])
      next if srcset_value.blank?

      tag.source(**options, srcset: srcset_value)
    end
  end

  def build_asset_srcset(entries)
    Array(entries).filter_map do |entry|
      case entry
      when Array
        source, descriptor = entry
        "#{path_to_image(source)} #{descriptor}"
      when Hash
        source = entry[:source]
        descriptor = entry[:descriptor]
        next if source.blank? || descriptor.blank?

        "#{path_to_image(source)} #{descriptor}"
      when String
        path_to_image(entry)
      end
    end.join(", ").presence
  end
end
