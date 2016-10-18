# Project 1 - *Gerbil Flicks*

**Gerbil Flicks** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **15** hours spent in total

## User Stories

The following **required** functionality is completed:

- [ ] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [ ] User can view movie details by tapping on a cell.
- [ ] User sees loading state while waiting for the API.
- [ ] User sees an error message when there is a network error.
- [ ] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [ ] Add a tab bar for **Now Playing** and **Top Rated** movies.
- [ ] Implement segmented control to switch between list view and grid view.
- [ ] All images fade in.
- [ ] For the large poster, load the low-res image first, switch to high-res when complete.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/ArTGF71.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Challenges:
- [ ] Resizing issues after forgetting to use auto-resize.
- [ ] Learning Swift syntax/features on the fly and getting comfortable with the language.
- [ ] Miscellaneous bugs related to views being instantiated through the tab controller e.g. not being able to propagate state consistently from one controller to the next. Ended up using a static property instead.
- [ ] Generally just learning how to use the UI classes.
 
## License

    Copyright [2016] [Gerbil Tech]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
