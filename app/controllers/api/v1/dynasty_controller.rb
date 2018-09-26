module Api
  module V1
    class DynastyController < ApplicationController
      skip_before_action :verify_authenticity_token

      def find_family
        person = Person.find_by(name: params[:person].capitalize)
        return false if person.nil?
        results_array = person.send(params[:relation].parameterize('_'))
        unless results_array.nil?
          render json: { collection: results_array.flatten.compact.map {|p|  p.name} }
        end
      end

      def add_child
        mother = Person.find_by(name: params[:mother].capitalize)
        params[:daughter].present? ? mother.daughters.create(name: params[:daughter], father: mother.spouse)
                                   : mother.sons.create(name: params[:son], father: mother.spouse)
      end


    end
  end
end
