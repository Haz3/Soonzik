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
        			if purchased_music.purchased_album == nil
	        			purchasedItems[:total_sell] += 1
	        			if ((Time.now.to_date - purchased_music.purchase.created_at.to_date).to_i > 7)
	        				purchasedItems[:lastweek] += 1
	        			end
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
        			if purchased_album.purchased_pack == nil
	        			purchasedItems[:total_sell] += 1
	        			if ((Time.now.to_date - purchased_album.purchased_musics[0].purchase.created_at.to_date).to_i > 7)
	        				purchasedItems[:lastweek] += 1
	        			end
	        		end
        		}
        		response[:album] << purchasedItems
        	}

        	# Calculate the musics sell
        	memory_pack = {}

        	current_user.albums.each { |album|
        		album.packs.each { |pack|
        			pack.purchased_packs.each { |purchased_pack|

	        			# if there is a pack and it was not defined before
	        			if !memory_pack.has_key?(pack.id) && purchased_pack.purchased_musics.size > 0
	        				memory_pack[pack.id] = {
			        			pack_title: pack.title,
			        			total_sell: 0,
			        			total_sell_partial: 0,
			        			lastweek: 0,
			        			lastweek_partial: 0,
			        			users: []
			        		}
		        		end

		        		# if the pack exist already and the user never buy it before
		        		if (!memory_pack[pack.id][:users].include?(current_user.id)) && purchased_pack.purchased_musics.size > 0
		        			memory_pack[pack.id][:total_sell] += 1
	        				memory_pack[pack.id][:total_sell_partial] += 1 if purchased_pack.partial
		        			if ((Time.now.to_date - purchased_pack.purchased_musics[0].purchase.created_at.to_date).to_i > 7)
		        				memory_pack[pack.id][:lastweek] += 1
		        				memory_pack[pack.id][:lastweek_partial] += 1 if purchased_pack.partial
		        			end
		        			memory_pack[pack.id][:users] << purchased_pack.purchased_musics[0].purchase.user.id	        			
	        			end

        			}
        		}
        	}

        	memory_pack.each { |key, value|
        		value.delete(:users)
        		response[:pack] << value
        	}

        	render :json => response
        }
  		end
  	end
  end
end