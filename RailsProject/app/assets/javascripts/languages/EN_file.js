/*
	Nomenclature :

	(display|file)_(position|controller)_(what is the text about)_(what kind of text)_(singular/plural)

	/-------------/

	Explication :

	display = front
	file = text generated from javascript file
	--------------
	position = where does come from the text
	controller = if it comes from file, the name of the controller
	---------------
	singular and plural are optionnal
*/

// From the header

var labels = {
	// Header View
	DISPLAY_MENU_NOTIFICATION_LABEL_SINGULAR: "Notification",
	DISPLAY_MENU_NOTIFICATION_LABEL_PLURAL: "Notifications",
	DISPLAY_MENU_PROFILE_EDITION_LABEL: "Edit profile",
	DISPLAY_MENU_NEWS_LABEL: "News",
	DISPLAY_MENU_EXPLORER_LABEL: "Explorer",
	DISPLAY_MENU_PACKS_LABEL: "Packs",
	DISPLAY_MENU_BATTLES_LABEL: "Battles",
	DISPLAY_MENU_FRIENDS_LABEL: "Friends",
	DISPLAY_MENU_SIGNUP_LABEL: "Sign up",
	DISPLAY_MENU_LOGIN_LABEL: "Login",
	DISPLAY_MENU_LOGOUT_LABEL: "Log out",
	DISPLAY_MENU_LANGUAGE_SELECTOR_LABEL: "Languages",	// To add

	// Album Controller
	FILE_ALBUM_GET_NOTES_ERROR_MESSAGE: "Error while loading your notes",
	FILE_ALBUM_FIND_PLAYLIST_ERROR_MESSAGE: "Error while deleting the playlist : ",
	FILE_ALBUM_GET_ALBUM_ERROR_MESSAGE: "Error while loading the album",
	FILE_ALBUM_ADD_PLAYLIST_NOTIF_SUCCESS_PART_ONE: "The music '",
	FILE_ALBUM_ADD_PLAYLIST_NOTIF_SUCCESS_PART_TWO: "' has been added to the playlist",
	FILE_ALBUM_ADD_PLAYLIST_ERROR_MESSAGE: "Error while saving a new music in the playlist",
	FILE_ALBUM_SET_NOTE_ERROR_MESSAGE: "Error while rating the music, please try later.",
	FILE_ALBUM_LOAD_COMMENT_ERROR_MESSAGE: "Error while loading commentaries",
	FILE_ALBUM_SEND_COMMENT_ERROR_MESSAGE: "Error while saving your comment, please try later",

	// Battle Controller
	FILE_BATTLE_LOAD_BATTLE_ERROR_MESSAGE: "Error while loading the page",
	FILE_BATTLE_LOAD_ARTIST_ONE_ERROR_MESSAGE: "Error while loading the profile of the first artist.",
	FILE_BATTLE_LOAD_ARTIST_TWO_ERROR_MESSAGE: "Error while loading the profile of the second artist.",
	FILE_BATTLE_NEED_AUTHENTICATION_ERROR_MESSAGE: "You need to be authenticated",
	FILE_BATTLE_VOTE_ERROR_MESSAGE: "An error occured while voting. Try again later.",
	FILE_BATTLE_ALREADY_VOTED_ERROR_MESSAGE: "This action is impossible : You already vote for this artist",
	FILE_BATTLE_VOTETEXT_LABEL: "Vote",
	FILE_BATTLE_VOTEDTEXT_LABEL: "You voted for this artist",
	FILE_BATTLE_CANCEL_TEXT_LABEL: "Cancel your old vote and vote for this artist !",

	// Chat Controller
	FILE_CHAT_GET_MESSAGE_ERROR_MESSAGE: "An error occured during the loading",

	// Explorer Controller
	FILE_EXPLORER_GET_INFLUENCES_ERROR_MESSAGE: "Error while loading the influences",
	FILE_EXPLORER_GET_GENRE_ERROR_MESSAGE: "Error while loading the genre",

	// Listening Controller
	FILE_LISTENING_AROUND_ERROR_MESSAGE: "Error while loading the music around you",
	FILE_LISTENING_INPOPUP_LISTENED_LABEL: " listened by ",

	// Notification Controller
	FILE_NOTIFICATION_TWEET_NOTIF_MESSAGE: " has tweeted something to you",
	FILE_NOTIFICATION_FRIEND_NOTIF_MESSAGE: " has added you as friend",
	FILE_NOTIFICATION_FOLLOW_NOTIF_MESSAGE: " follow you",
	FILE_NOTIFICATION_ASREAD_NOTIF_ERROR_MESSAGE: "Can't mark your notification as read",
	FILE_NOTIFICATION_MORE_NOTIF_ERROR_MESSAGE: "An error occured, can't get more notifications. Try Later.",

	// Player Controller
	FILE_PLAYER_FIND_PLAYLIST_ERROR_MESSAGE: "Error : Can't get your playlist",
	FILE_PLAYER_DELETE_PLAYLIST_ERROR_MESSAGE: "Error while deleting the playlist : ",
	FILE_PLAYER_REMOVE_FROM_PLAYLIST_ERROR_MESSAGE: "Error while deleting the music from the playlist",
	FILE_PLAYER_SAVE_IN_PLAYLIST_ERROR_MESSAGE: "Error while saving a new music in the playlist",
	FILE_PLAYER_PLAY_MUSIC_ERROR_MESSAGE: "Error while loading the music : ",
	FILE_PLAYER_GEOLOC_MUSIC_ERROR_MESSAGE: "Can't add a music for geolocation",

	// Playlist Controller
	FILE_PLAYLIST_BAD_ARGUMENT_ERROR_MESSAGE: "Can't load this playlist",
	FILE_PLAYLIST_FIND_PLAYLIST_ERROR_MESSAGE: "Error while deleting the playlist : ",
	FILE_PLAYLIST_GET_PLAYLIST_ERROR_MESSAGE: "Error while loading information of the playlist",
	FILE_PLAYLIST_GET_MUSIC_ERROR_MESSAGE: "Error while loading information of the music number ",
	FILE_PLAYLIST_TMP_NAME_LABEL: "Temporary Playlist",
	FILE_PLAYLIST_SAVE_PLAYLIST_ERROR_MESSAGE: "Error while saving a new playlist",
	FILE_PLAYLIST_NEW_MUSIC_ERROR_MESSAGE: "Error while saving a new music in the playlist",

	// Search Controller
	FILE_SEARCH_REQUEST_ERROR_MESSAGE: "An error occured while loading the results of your search",

	// User Controller
	FILE_USER_MONTHS_INFORMATION: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
	FILE_USER_FIND_PLAYLIST_ERROR_MESSAGE: "Error while deleting the playlist : ",
	FILE_USER_GET_NOTES_ERROR_MESSAGE: "Error while loading your notes",
	FILE_USER_GET_FOLLOWERS_ERROR_MESSAGE: "An error occured while loading the followers of this profile",
	FILE_USER_GET_FOLLOWS_ERROR_MESSAGE: "An error occured while loading the follows of this profile",
	FILE_USER_GET_FRIENDS_ERROR_MESSAGE: "An error occured while loading the friends of this profile",
	FILE_USER_GET_PLAYLISTS_ERROR_MESSAGE: "An error occured while loading the playlists of this profile",
	FILE_USER_PROFILE_ERROR_MESSAGE: "An error occured while loading this profile",
	FILE_USER_EDITION_ERROR_MESSAGE: "You can't edit this profile : it is not yours",
	FILE_USER_UPDATE_SUCCESS_MESSAGE: "Profile updated successfully",
	FILE_USER_ERROR_OCCURED_MESSAGE: "An error occured",
	FILE_USER_FOLLOW_ERROR_MESSAGE: "An error occured while following an user",
	FILE_USER_FRIEND_ERROR_MESSAGE: "An error occured while adding a friend",
	FILE_USER_UNFOLLOW_ERROR_MESSAGE: "An error occured while unfollowing an user",
	FILE_USER_UNFFRIEND_ERROR_MESSAGE: "An error occured while removing a friend",
	FILE_USER_SAVE_TWEET_ERROR_MESSAGE: "Error while saving the tweet",
	FILE_USER_TWEET_TOO_LONG_ERROR_MESSAGE: "Your message is too big. Length max. is 140 characters.",
	FILE_USER_SET_NOTE_ERROR_MESSAGE: "Error while rating the music, please try later.",
	FILE_USER_NEED_LOGIN_ERROR_MESSAGE: "You need to login for this action",
	FILE_USER_ADD_PLAYLIST_ERROR_MESSAGE: "Error while saving a new music in the playlist",
	FILE_USER_FB_LINKED_ERROR_MESSAGE: "The Facebook account is already linked to another SoonZik account",
	FILE_USER_FB_LINK_ERROR_MESSAGE: "Can't link the social network to your profile, try again later.",
	FILE_USER_GOOGLE_LINKED_ERROR_MESSAGE: "The Google Plus account is already linked to another SoonZik account",
	FILE_USER_GOOGLE_LINK_ERROR_MESSAGE: "Can't link the social network to your profile, try again later.",
	FILE_USER_GOOGLE_CONNECTION_ERROR_MESSAGE: "Can't connect to Google, please try later",

	// Album Show View
	DISPLAY_ALBUM_ADD_PLAYLIST_BUTTON: "Add to Playlist",
	DISPLAY_ALBUM_ADD_PLAYLIST_LABEL: "Add",
	DISPLAY_ALBUM_LISTEN_LABEL: "Listen",
	DISPLAY_ALBUM_CLOSE_LABEL: "Close",
	DISPLAY_ALBUM_SEND_COMMENT_BUTTON: "Send",

	// Battle Index View
	DISPLAY_BATTLE_LIST_LABEL: "List of battles",
	DISPLAY_BATTLE_LINK_TO_SHOW_LABEL: "Page of the battle",

	// Battle Show View
	DISPLAY_BATTLE_TOP_LABEL: "Top music of ",
	DISPLAY_BATTLE_NO_MUSIC_LABEL: "No music yet !",
	DISPLAY_BATTLE_THEY_VOTED_LABEL: "They voted for an artist...",

	// Explorer Index View
	DISPLAY_EXPLORER_INDEX_LABEL: "Index",
	DISPLAY_EXPLORER_INFLUENCE_CHOOSE_LABEL: "Choose an influence",
	DISPLAY_EXPLORER_GENRE_LABEL: "genres",

	// Listening Index View
	DISPLAY_LISTENING_ERROR_GEOLOCATION_LABEL: "Your browser doesn't support geolocation, please update it or choose another one",
	DISPLAY_LISTENING_WAITING_LABEL: "Waiting...",
	DISPLAY_LISTENING_INFORMATION_LABEL: "We are getting your position, if you didn't already allowed your browser to give us your location, you need to accept to access to this feature.",
	DISPLAY_LISTENING_RANGE_LABEL: "You search in a range of :",

	// Notification Index View
	DISPLAY_NOTIFICATION_NEW_LABEL: "New Notifications",
	DISPLAY_NOTIFICATION_OLD_LABEL: "Old Notifications",
	DISPLAY_NOTIFICATION_MORE_LABEL: "See more...",

	// Player view
	DISPLAY_PLAYER_CURRENT_PLAYLIST_LABEL: "Current Playlist",
	DISPLAY_PLAYER_CLEAN_LABEL: "Clean",
	DISPLAY_PLAYER_GEOLOCATION_LABEL: "Geolocation",
	DISPLAY_PLAYER_SHARE_LABEL: "Share",
	DISPLAY_PLAYER_SAVE_NEW_PLAYLIST_LABEL: "Save as new Playlist",
	DISPLAY_PLAYER_SAVE_PLAYLIST_NAME_LABEL: "Save the playlist as :",
	DISPLAY_PLAYER_SAVE_LABEL: "Save",
	DISPLAY_PLAYER_CLOSE_BUTTON: "Close",
	DISPLAY_PLAYER_TITLE_LABEL: "Title",
	DISPLAY_PLAYER_PRICE_LABEL: "Price",
	DISPLAY_PLAYER_DURATION_LABEL: "Duration",
	DISPLAY_PLAYER_ALBUM_LABEL: "Album",
	DISPLAY_PLAYER_ALBUM_LINK_LABEL: "Link to the album page",
	DISPLAY_PLAYER_YOUR_PLAYLIST_LABEL: "Your playlists",
	DISPLAY_PLAYER_NAME_LABEL: "Name",
	DISPLAY_PLAYER_REPLACE_PLAYLIST_BUTTON: "Replace the current playlist",
	DISPLAY_PLAYER_ADD_CURRENT_PLAYLIST_BUTTON: "Add to the current playlist",
	DISPLAY_PLAYER_SHARE_PLAYLIST_BUTTON: "Share this link !",
	DISPLAY_PLAYER_SURE_DELETE_BUTTON: "Are you sure to delete this playlist ?",
	DISPLAY_PLAYER_YES_BUTTON: "Yes",
	DISPLAY_PLAYER_NO_BUTTON: "No",

	// Playlist view
	DISPLAY_PLAYER_EMPTY_LABEL: "This playlist is empty",
	DISPLAY_PLAYER_FROM_LABEL: "From",
	DISPLAY_PLAYER_MUSICS_LABEL: "musics",
	DISPLAY_PLAYER_LISTEN_LABEL: "Listen",
	DISPLAY_PLAYER_SHARE_LABEL: "Share",
	DISPLAY_PLAYER_CLOSE_LABEL: "Close",
	DISPLAY_PLAYER_NEW_PLAYLIST_LABEL: "Save as new playlist",
	DISPLAY_PLAYER_SAVE_AS_LABEL: "Save as : ",
	DISPLAY_PLAYER_SAVE_BUTTON: "Save",
	DISPLAY_PLAYER_ADD_PLAYLIST_LABEL: "Add to playlist",
	DISPLAY_PLAYER_ADD_PLAYLIST_BUTTON: "Add",

	// Search view
	DISPLAY_SEARCH_FILTERS_LABEL: "Filters",
	DISPLAY_SEARCH_ALL_FILTER_LABEL: "All",
	DISPLAY_SEARCH_USER_FILTER_LABEL: "Users",
	DISPLAY_SEARCH_ARTIST_FILTER_LABEL: "Artists",
	DISPLAY_SEARCH_ALBUM_FILTER_LABEL: "Albums",
	DISPLAY_SEARCH_MUSIC_FILTER_LABEL: "Musics",
	DISPLAY_SEARCH_PACK_FILTER_LABEL: "Packs",
	DISPLAY_SEARCH_SEARCH_LABEL: "Search",
	DISPLAY_SEARCH_NOTHING_LABEL: "Nothing found",
	DISPLAY_SEARCH_ALBUM_FROM_LABEL: "From the album",
	DISPLAY_SEARCH_BY_LABEL: "By",

	// User _form view
	DISPLAY_USER_FORM_IMAGES_LABEL: "Images",
	DISPLAY_USER_FORM_AVATAR_LABEL: "Avatar",
	DISPLAY_USER_FORM_IMAGE_LOAD_LABEL: "Load an image",
	DISPLAY_USER_FORM_IMAGE_LABEL: "Image",
	DISPLAY_USER_FORM_BACKGROUND_LABEL: "Background",
	DISPLAY_USER_FORM_PUBLIC_INFO_LABEL: "Public informations",
	DISPLAY_USER_FORM_USERNAME_LABEL: "Username",
	DISPLAY_USER_FORM_EMAIL_LABEL: "Email",
	DISPLAY_USER_FORM_DESCRIPTION_LABEL: "Description",
	DISPLAY_USER_FORM_BIRTHDAY_LABEL: "Birthday",
	DISPLAY_USER_FORM_FB_LABEL: "Facebook",
	DISPLAY_USER_FORM_TWITTER_LABEL: "Twitter",
	DISPLAY_USER_FORM_GPLUS_LABEL: "Google Plus",
	DISPLAY_USER_FORM_PERSO_INFO_LABEL: "Personnal informations",
	DISPLAY_USER_FORM_FIRSTNAME_LABEL: "Firstname",
	DISPLAY_USER_FORM_LASTNAME_LABEL: "Lastname",
	DISPLAY_USER_FORM_PASSWORD_LABEL: "Password",
	DISPLAY_USER_FORM_PHONE_LABEL: "Phone",
	DISPLAY_USER_FORM_NEWSLETTER_LABEL: "Newsletter",
	DISPLAY_USER_FORM_LANGUAGE_LABEL: "Language",
	DISPLAY_USER_FORM_LINKS_LABEL: "Link your account allows you to connect thanks to it to SoonZik",
	DISPLAY_USER_FORM_FB_LINK_LABEL: "Link your account with Facebook :",
	DISPLAY_USER_FORM_FB_LOG_LABEL: "Login with Facebook",
	DISPLAY_USER_FORM_TWITTER_LINK_LABEL: "Link your account with Twitter :",
	DISPLAY_USER_FORM_TWITTER_LOG_LABEL: "Login with Twitter",
	DISPLAY_USER_FORM_GPLUS_LINK_LABEL: "Link your account with Google Plus :",
	DISPLAY_USER_FORM_GPLUS_LOG_LABEL: "Login with Google Plus",
	DISPLAY_USER_FORM_LINKED_LABEL: "Your account is linked",
	DISPLAY_USER_FORM_NUMBER_LABEL: "Number in the street",
	DISPLAY_USER_FORM_COMPLEMENT_LABEL: "Complement",
	DISPLAY_USER_FORM_STREET_LABEL: "Street",
	DISPLAY_USER_FORM_CITY_LABEL: "City",
	DISPLAY_USER_FORM_COUNTRY_LABEL: "Country",
	DISPLAY_USER_FORM_ZIPCODE_LABEL: "Zipcode",

	// User show view
	DISPLAY_USER_ARTIST_TOP_LABEL: "Top Songs",
	DISPLAY_USER_TITLE_SONG_LABEL: "Title",
	DISPLAY_USER_DURATION_SONG_LABEL: "Duration",
	DISPLAY_USER_PRICE_SONG_LABEL: "Price",
	DISPLAY_USER_RATE_AV_SONG_LABEL: "Rate (average)",
	DISPLAY_USER_ADD_PLAYLIST_LABEL: "Add to playlist",
	DISPLAY_USER_ADD_BUTTON: "Add",
	DISPLAY_USER_LISTEN_LABEL: "Listen",
	DISPLAY_USER_CLOSE_BUTTON: "Close",
	DISPLAY_USER_ALBUMS_LABEL: "Albums",
	DISPLAY_USER_PACKS_LABEL: "Packs",
	DISPLAY_USER_TWEETS_LABEL: "Tweets",
	DISPLAY_USER_TWEETS_CHARACTERS_LABEL: "characters left",
	DISPLAY_USER_ANSWER_LABEL: "Answer",
	DISPLAY_USER_MUSICS_LABEL: "musics",
	DISPLAY_USER_PLAYLIST_DURATION_LABEL: "Duration (total)",
	DISPLAY_USER_MORE_LABEL: "More...",

	// Chat view
	DISPLAY_CHAT_PLACEHOLDER_INPUT_LABEL: "Search a friend",
	DISPLAY_CHAT_CONNECTED_LABEL: "Connected friend",
	DISPLAY_CHAT_DISCONNECTED_LABEL: "Disconnected friend",
}