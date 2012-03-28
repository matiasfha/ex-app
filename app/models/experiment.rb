class Experiment < ActiveRecord::Base

	has_many :user_filters
	has_many :experiment_videos
    has_many :videos, :through => :experiment_videos
    has_many :user_experiments
    has_many :users, :through => :user_experiments
    has_many :user_experiment_videos


    def do_i_fit_in? (u)
    	fits = true
    	all_filters = [[nil],[],[],[],[],[],[]]
        self.user_filters.each do |f|
          all_filters[f.filter_type].push f.value
        end
        i = 0
        all_users = User.all
        all_filters.each do |af|
          if i==1&&!af.empty?
            matches = false
            af.each do |e|
              name = u.first_name+' '+u.last_name
              if name.include? e
                matches = true
              end
            end
            if !matches
              fits = false
            end
          elsif i==2&&!af.empty?
            matches = false
            af.each do |e|
              ages = e.split(',')
              min = Integer(ages[0])
              max = Integer(ages[1])
              if min.years.ago>u.birthdate&&max.years.ago<u.birthdate
                matches = true
              end
            end
            if !matches
              fits = false
            end
          elsif i==3&&!af.empty?
            matches = false
            af.each do |e|
              if true
                sex_id = Integer(e)
                sex = Sex.find_by_id(sex_id)
                if !sex||(u.sex&&u.sex.id==sex.id)
                  matches = true
                end
              end
            end
            if !matches
              fits = false
            end
          elsif i==4&&!af.empty?
            matches = false
            af.each do |e|
              if true
                country_id = Integer(e)
                country = Country.find_by_id(country_id)
                if !country||(u.country&&u.country.id==country.id)
                  matches = true
                end
              end
            end
            if !matches
              fits = false
            end
          elsif i==5&&!af.empty?
            matches = false
            af.each do |e|
              if true
                city_id = Integer(e)
                city = City.find_by_id(city_id)
                if !city||(u.city&&u.city.id==city.id)
                  matches = true
                end
              end
            end
            if !matches
              fits = false
            end
          elsif i==6&&!af.empty?
            matches = false
            af.each do |e|
              if true
                commune_id = Integer(e)
                commune = Commune.find_by_id(commune_id)
                if !commune||(u.commune&&u.commune.id==commune.id)
                  matches = true
                end
              end
            end
            if !matches
              fits = false
            end
          else
            #otros filtros
    
          end
          i += 1
        end

    	return fits
    end

end
