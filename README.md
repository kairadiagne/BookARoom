# BookARoom

**Approach**

I've set out to complete as much as possible of the assignment in the allocated 3 hours. I did this by setting a timer at the time I set down to tackle the assignment.

I started with creating a very basic viewcontroller, after which I implemented the fetching of the rooms. I've tried to use combine for the network calls and the binding, since I was curious how that would play out.

After the initial data was being loaded, I set out to convert the web design to a mobile friendly one. In the order of saving time I stuck to an iPhone 11 Pro, in portrait mode only.

Once I was satisfied enough with the layout, I went on to implement a very basic caching mechanism, where I store old responses in UserDefaults. I contemplated using CoreData, but in the interest of time I went with the more simplistic approach. Furthermore, I believed that CoreData might have been a bit of overkill in this case.

Lastly, I implemented the call to book a room, also using combine. Once this was done my timer was about to go off and unfortunately I did not have time to do anything else..

**TODO**

- Obviously, the tests are currently missing. I forgot to set myself time in the end to implement those.
I think the `RoomViewModel` should be fairly easy to test. However, the `RoomCellViewModel` might need some abstraction in order to be nicely tested.

- I was trying to handle the booking of a room a bit nicer, the available spots do countdown at the moment, however, the button does not change color/disable properly when the count hits 0. I was somewhat struggling with this implementation when my timer went off.

- Further improvements would include, landscape and iPad support. Which might include a little bit more polishing of the design as well.
Caching could be taken to CoreData, so it would be synchronizable across devices, but I'm not entirely sure if that would be required for this app.