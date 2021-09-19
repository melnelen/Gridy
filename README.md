# Gridy - Test report

## Features tested
- Design on iPhone Portrait & Landscape
- Start game with a random image
- Start game with a photo library image
- Edit (scale, totate and translate) the selected image
- Double tap to reset the edited image
- Pieces can be dragged and droped in any container
- Pieces can not be draged and droped outside of a container or on top of another pieces
- Sound can be mutted/unmutted (I had some issue after a while)
- Game can be completed
- Score is increasing

## Features not tested
- Start game with a photo taken with the camera
- Share with social network (however, the share feature is available)


## Bug founds
### In Start screen
- The app crash the very first time I try to access the photo library (Seems related to the Apple popup to grant the app an access to the photo library)

### In Edit screen
- With the right scale/rotation, i can start the game with an empty image
- When I translate my image too far, I can no longer edit, the double tap won't work either

### In game screen
- Once the game is completed, I can move again the pieces, the move count will keep increasing and I can finish the game again
- At some point, the soud stop working, not so sure why
- [Minor UX issues] When going fast I sometime drag down the entire game screen instead of a puzzle piece

