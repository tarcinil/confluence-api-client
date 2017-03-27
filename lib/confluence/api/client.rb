require "confluence/api/client/version"
require 'json'
require 'faraday'

module Confluence
  module Api
    class Client
      attr_accessor :user, :pass, :url, :conn, :multiconn
      def initialize(user, pass, url)
        self.user = user
        self.pass = pass
        self.url = url
        self.conn = Faraday.new(url: url ) do |faraday|
          faraday.request  :url_encoded             # form-encode POST params
          # faraday.response :logger                  # log requests to STDOUT
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
          faraday.basic_auth(self.user, self.pass)
        end
        self.multiconn = Faraday.new(url: url ) do |faraday|
          faraday.request  :multipart             # form-encode POST params
          # faraday.response :logger                  # log requests to STDOUT
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
          faraday.basic_auth(self.user, self.pass)
        end


      end

      def get(params)
        response = conn.get('/wiki/rest/api/content', params)
        JSON.parse(response.body)['results']
      end

      def get_by_id(id)
        response = conn.get('/wiki/rest/api/content/' + id)
        JSON.parse(response.body)
      end

      def upload_png(id,file_path)
        puts file_path
        response = multiconn.post do |req|
          req.url '/wiki/rest/api/content/'+id+'/child/attachment'
          req.headers['X-Atlassian-Token']= 'nocheck'
          req.body= {file: Faraday::UploadIO.new(File.open(file_path), 'image/png') }
        end
        JSON.parse(response.body)
      end


      #def update_png

      def create(params)
        response = conn.post do |req|
          req.url '/wiki/rest/api/content'
          req.headers['Content-Type'] = 'application/json'
          req.body = params.to_json
        end
        JSON.parse(response.body)
      end

      def update(id, params)
        response = conn.put do |req|
          req.url "/wiki/rest/api/content/#{id}"
          req.headers['Content-Type'] = 'application/json'
          req.body = params.to_json
        end
        JSON.parse(response.body)
      end

    end
  end
end
