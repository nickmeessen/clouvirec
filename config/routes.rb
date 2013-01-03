Clouvirec::Application.routes.draw do

  # scope "/clouvirec" do

    root :to => "home#index"

    post 'clouvirec' => "home#index"

    get 'shows' => "shows#index"
    get 'shows/recent' => "shows#recent"
    get 'shows/upcoming' => "shows#upcoming"
    post 'shows/search' => "shows#search"

    get 'shows/:id/banner' => "shows#banner"
    get 'shows/:id/poster' => "shows#poster"
    get 'shows/:id/seasons' => "shows#seasons"
    post 'shows/:id/track' => "shows#track"
    post 'shows/:id/untrack' => "shows#untrack"

    get 'episodes/:showid/:seasonnr' => "episodes#index"
    get 'episodes/:showid/:seasonnr/:episodeid' => "episodes#download"
    post 'episodes/:showid/:seasonnr/:episodeid/request' => "episodes#req"
    get 'episodes/:showid/:seasonnr/:episodeid/request' => "episodes#req"

    get 'notifies/post' => "notifies#post"
    get 'notifies/test' => "notifies#test"

    ## Backroutes

    # post 'episodes/:showid/:seasonnr/:episodeid/delete' => "episodes#delete"
    # get 'users/destroy/:id' => 'users#destroy' #?

  # end


end
