class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name "myflix_#{Rails.env}"

  validates_presence_of :title, :description
  belongs_to :category
  has_many :reviews, -> { order "created_at DESC" }

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def self.search_by_title(search_string)
    return [] if search_string.blank?
    Video.where('title LIKE ?', "%#{search_string}%").order('created_at DESC')
  end

  def rating
    video_rating = self.reviews.average(:rating)
    video_rating.round(1) if video_rating
  end

  def self.search(query, options={})
    search_definition = {
      query: {
        multi_match: {
          query: query,
          fields: [ "title^100", "description^50" ],
          operator: "and",
        }
      }
    }

    if query.present?
      if options[:reviews]
        search_definition[:query][:multi_match][:fields] << "reviews.body"
      end

      if options[:rating_from] || options[:rating_to]
        search_definition[:filter] = {
          range: {
            rating: {
              gte: (options[:rating_from] if options[:rating_from].present?),
              lte: (options[:rating_to] if options[:rating_to].present?),
            }
          }
        }
      end
    end

    __elasticsearch__.search(search_definition)
  end

  def as_indexed_json(options={})
    as_json(
      methods: :rating,
      only: [:title, :description],
      include: {
        reviews: { only: :body }
      }
    )
  end
end
