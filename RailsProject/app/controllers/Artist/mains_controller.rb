module Artist
  # Controller which manage main page of the artist panel
  #
  class MainsController < ArtistsController
  	def home
  	end

  	def stats
  		respond_to do |format|
  			format.html { redirect_to artist_root_path }
        format.json {
        	response = {
        		music: [],
        		album: [],
        		pack: []
        	}

        	# Calculate the musics sell
        	current_user.musics.each { |music|
        		purchasedItems = {
        			music_title: music.title,
        			total_sell: 0,
        			lastweek: 0
        		}
        		music.purchased_musics.each { |purchased_music|
        			purchasedItems[:total_sell] += 1
        			if ((Time.now.to_date - purchased_music.purchase.created_at.to_date).to_i > 7)
        				purchasedItems[:lastweek] += 1
        			end
        		}
        		response[:music] << purchasedItems
        	}

        	# Calculate the albums sell
        	current_user.albums.each { |album|
        		purchasedItems = {
        			album_title: album.title,
        			total_sell: 0,
        			lastweek: 0
        		}
        		album.purchased_albums.each { |purchased_album|
        			purchasedItems[:total_sell] += 1
        			if ((Time.now.to_date - purchased_album.purchased_musics[0].purchase.created_at.to_date).to_i > 7)
        				purchasedItems[:lastweek] += 1
        			end
        		}
        		response[:album] << purchasedItems
        	}

        	render :json => response
        }
  		end
  	end
  end
end