# For the personnal asset precompilation

Rails.application.config.assets.precompile << Proc.new do |path|
  if path =~ /\.(css|js|scss)\z/
    full_path = Rails.application.assets.resolve(path).to_s
    app_assets_path = Rails.root.join('app', 'assets').to_s
    if full_path.starts_with? app_assets_path
      Rails.logger.info "including asset: " + full_path
      true
    else
      Rails.logger.info "excluding asset: " + full_path
      false
    end
  else
    false
  end
end

Rails.application.config.assets.precompile += %w(websocket_rails/main.js)

=begin
#JS
Rails.application.config.assets.precompile += %w(accesses.js)
Rails.application.config.assets.precompile += %w(addresses.js)
Rails.application.config.assets.precompile += %w(album_notes.js)
Rails.application.config.assets.precompile += %w(albums.js)
Rails.application.config.assets.precompile += %w(attachments.js)
Rails.application.config.assets.precompile += %w(battles.js)
Rails.application.config.assets.precompile += %w(carts.js)
Rails.application.config.assets.precompile += %w(commentaries.js)
Rails.application.config.assets.precompile += %w(concerts.js)
Rails.application.config.assets.precompile += %w(description.js)
Rails.application.config.assets.precompile += %w(flacs.js)
Rails.application.config.assets.precompile += %w(genres.js)
Rails.application.config.assets.precompile += %w(gifts.js)
Rails.application.config.assets.precompile += %w(groups.js)
Rails.application.config.assets.precompile += %w(influences.js)
Rails.application.config.assets.precompile += %w(listenings.js)
Rails.application.config.assets.precompile += %w(messages.js)
Rails.application.config.assets.precompile += %w(music_notes.js)
Rails.application.config.assets.precompile += %w(musics.js)
Rails.application.config.assets.precompile += %w(news.js)
Rails.application.config.assets.precompile += %w(newstexts.js)
Rails.application.config.assets.precompile += %w(notification.js)
Rails.application.config.assets.precompile += %w(others.js)
Rails.application.config.assets.precompile += %w(packs.js)
Rails.application.config.assets.precompile += %w(playlists.js)
Rails.application.config.assets.precompile += %w(propositions.js)
Rails.application.config.assets.precompile += %w(purchases.js)
Rails.application.config.assets.precompile += %w(tags.js)
Rails.application.config.assets.precompile += %w(tweets.js)
Rails.application.config.assets.precompile += %w(users.js)
Rails.application.config.assets.precompile += %w(votes.js)

#SASS
Rails.application.config.assets.precompile += %w(accesses.css.scss)
Rails.application.config.assets.precompile += %w(addresses.css.scss)
Rails.application.config.assets.precompile += %w(album_notes.css.scss)
Rails.application.config.assets.precompile += %w(albums.css.scss)
Rails.application.config.assets.precompile += %w(attachments.css.scss)
Rails.application.config.assets.precompile += %w(battles.css.scss)
Rails.application.config.assets.precompile += %w(carts.css.scss)
Rails.application.config.assets.precompile += %w(commentaries.css.scss)
Rails.application.config.assets.precompile += %w(concerts.css.scss)
Rails.application.config.assets.precompile += %w(description.css.scss)
Rails.application.config.assets.precompile += %w(flacs.css.scss)
Rails.application.config.assets.precompile += %w(genres.css.scss)
Rails.application.config.assets.precompile += %w(gifts.css.scss)
Rails.application.config.assets.precompile += %w(groups.css.scss)
Rails.application.config.assets.precompile += %w(influences.css.scss)
Rails.application.config.assets.precompile += %w(listenings.css.scss)
Rails.application.config.assets.precompile += %w(messages.css.scss)
Rails.application.config.assets.precompile += %w(music_notes.css.scss)
Rails.application.config.assets.precompile += %w(musics.css.scss)
Rails.application.config.assets.precompile += %w(news.css.scss)
Rails.application.config.assets.precompile += %w(newstexts.css.scss)
Rails.application.config.assets.precompile += %w(notification.css.scss)
Rails.application.config.assets.precompile += %w(others.css.scss)
Rails.application.config.assets.precompile += %w(packs.css.scss)
Rails.application.config.assets.precompile += %w(playlists.css.scss)
Rails.application.config.assets.precompile += %w(propositions.css.scss)
Rails.application.config.assets.precompile += %w(purchases.css.scss)
Rails.application.config.assets.precompile += %w(tags.css.scss)
Rails.application.config.assets.precompile += %w(tweets.css.scss)
Rails.application.config.assets.precompile += %w(users.css.scss)
Rails.application.config.assets.precompile += %w(votes.css.scss)
=end