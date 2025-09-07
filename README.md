<div align="center">
    <img src="https://readme-typing-svg.demolab.com/?font=Cartograph%20CF%20Italic&weight=700&size=76&pause=0&duration=1&color=A9A9A9&background=000A0E&center=true&vCenter=true&width=600&height=150&repeat=false&lines=Quartz">
</div>

> [!NOTE]
>  Target end-user of this tool: individuals aiming to take control of their lives one day at a time by:
>    * eliminating self-destructive habits and time-sinks such as unrestricted internet access.
>    * cultivating new good habits.
>    * maximizing and optimizing the process of acquiring new knowledge.
### Philosophy of Quartz:
- Connecting to the internet should be a conscious decision.
- Connecting to the internet should be ***hard*** and disconnecting should be ***easy*** to encourage using it more moderately.
- On average it takes 2 months to form a new habit. To help reach this time goal, It's important to track it closely to not forget and relapse.
- Explaining what was learned to a critical audience is important to identify holes in understanding (The Feynman technique).

### How does Quartz help?
`quartz` has four main sub-commands:
- `net`: Through this command you will control your internet access. you can `enable` your current internet interface (after configuring it). you also configure a `max-net-time` parameter (in minutes) which is the maximum time for which the internet can be continuously in-use. when this time finishes, quartz will disable your current network interface. after that you can either manually enable it to continue what you were doing using `net` (causing the timer to start again) or do something more useful. The idea is by segmenting internet usage into `max-net-time`-long sessions you can be more conscious of what you do on the internet and how much time it consumes. allowing you to reflect and reconsider what you do or organize your time more wisely. </br>
  (details of how the process of enabling internet-access will be hard is not yet decided) </br>
  ### ***Examples:*** <br/>
  ```
  quartz net --enable-interace wlan0 # you have to explicitly use the full command
  quartz net                         # no arguments disables internet by default for convenience
  ```

- `habit`: Through this command, you can register habits you want to build/destroy. as of now this command's only use is to store habit information for `fetch` (see `fetch`). The `habit-automaticity` key in the config sets the personal time to build a good habit whereas `habit-removal` sets personal time to remove one (quartz will pick reasonable defaults for both keys).
  ### ***Examples:*** <br/>
  ```
  quartz habit --build 'spending less than 4 hours everyday online' # can use `-b` as shorthand
  quartz habit --destroy 'missing fajr and isha prayers'            # can use `-d` as shorthand
  ```
  
- `feynman`: This command takes a topic name as an argument then spawns an interactive TUI chat with an LLM agent. you then explain all what you've learned about this topic in depth and the AI will test your understanding by asking questions on the clarity, completeness, internal/external consistency, and correctness of your explanation. through these questions you'll identify the holes in your understanding and the points you may have misunderstood. <br/>
  ### ***Example:*** <br/>
  ```
  quartz feynman 'How gravity is modelled in relativity'
  ```
  
- `fetch`: Displays all available statistics and information including: <br/>
  - habit stats: how many days left to reach each personal automaticity point per good habit and how many days left to destroy each bad habit. <br/>
  - *more to come...* <br/>
