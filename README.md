# Project 1 - *Hollywoo*

**Hollywoo** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **9** hours spent in total

## User Stories

The following **required** functionality is complete:

- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [ ] User sees an error message when there's a networking error.
- [ ] Movies are displayed using a CollectionView instead of a TableView.
- [ ] User can search for a movie.
- [x] All images fade in as they are loading.
- [x] Customize the UI: icons and spacing

The following **additional** features are implemented:

- [x] Low resolution images are loaded before the large resolution 

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/UfFSLJ0.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

One of the challenges I encountered was trying to incorporate icons into the app. I was unaware that Xcode didn't automatically reformat the icons, so I have to do the resizing myself through trial and error or through dimensions retrieved online. Another issue was the loading screen——it took awhile for me to get use to the way Cocoapods operated. 

## License

    Copyright 2015 Jiaqi Wu

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
