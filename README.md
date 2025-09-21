<div align="center">
    <img src="https://readme-typing-svg.demolab.com/?font=Cartograph%20CF%20Italic&weight=700&size=76&pause=0&duration=1&color=A9A9A9&background=000A0E&center=true&vCenter=true&width=600&height=150&repeat=false&lines=Quartz">
</div>

> [!NOTE]
>  Target end-user of this tool: individuals aiming to take control of their lives one day at a time by:
>    * eliminating self-destructive habits and time-sinks such as unrestricted internet access.
>    * cultivating new good habits.
>    * maximizing and optimizing the process of acquiring new knowledge.
### Philosophy of Quartz:
- `R1`: Connecting to the internet should be a conscious decision.
- `R2`: Connecting to the internet should be ***hard*** and disconnecting should be ***easy*** to encourage using it more moderately.
- `R3`: On average it takes 2 months to form a new habit. To help reach this time goal, It's important to track it closely to not forget and relapse.
- `R4`: Explaining what was learned to a critical audience is important to identify holes in understanding (The Feynman technique).
- `R5`: reliance on AI should be minimized and restricted to not develop cognitive debt. 

## How does Quartz help?
`quartz` has five main sub-commands:
### `net`:
Through this command you will control your internet access. configure internet-access levels using `net-level-N` config keys where N is a positive integer. the value for each key is a set of domains that you allow acccess to. `net-level-0` is always set to `[]` (internet access is fully disabled). `net-level-1` can have a set of work/study/research related domains that you need. `net-level-2`  can contain a set of domains for messaging and `net-level-3` can be full unrestricted internet-access (you can configure any number of levels you want). each level is a superset of the lower level. for each level there is a corresponding settings structure containing the condition to jump to the level (e.g: to jump to level N, the current hour must be divisible by 3, thereby limiting how often you can jump up a level. However, you can jump down at any time, thus achieving `R2`), and the level's `level-time` which is the maximum time you can continuously spend on that level. after that time finishes you get kicked to the lower level (naturally, the higher the level the lower the `level-time`). after that you can either manually bump the current level up (in the nearest time the conditions for jumping to the level are met again) to continue what you were doing (causing the timer to start again) or do something more useful. The idea is by segmenting internet usage into sessions on different levels you can be more conscious of what you do on the internet and how much time it consumes. allowing you to reflect and reconsider what you do or organize your time more wisely. <br/>
  ### ***Examples:*** <br/>
  ```
  quartz net +2     # jump up two levels (you're not allowed to jump from level 0 to the highest level at once.)
  quartz net        # drops down to the `quartz-net-default-level` specified in the configuration
  ```

### `habit`
Through this command, you can register habits you want to build/destroy. as of now this command's only use is to store habit information for `fetch` to be used as a digitized calender to track when will habit automaticity be reached (see `fetch`). The `habit-automaticity` key in the config sets the personal time to build a good habit whereas `habit-removal` sets personal time to remove a bad habit (quartz will pick reasonable defaults for both keys).
  ### ***Examples:*** <br/>
  ```
  quartz habit --build 'spending less than 4 hours everyday online' # can use `-b` as shorthand
  quartz habit --destroy 'missing fajr and isha prayers'            # can use `-d` as shorthand
  ```
  
### `feynman`:
This command takes a topic name as an argument then spawns an interactive TUI chat with an LLM agent. you then explain all what you've learned about this topic in depth and the AI will test your understanding by asking questions on the clarity, completeness, internal/external consistency, and correctness of your explanation. through these questions you'll identify the holes in your understanding and the points you may have misunderstood. <br/>
  ### ***Example:*** <br/>
  ```
  quartz feynman 'How gravity is modelled in relativity'
  ```

### `search`:
Searches the internet for resources and answers but doesn't serve up information on a silver plate. instead it gives you the resources forcing you to not fully rely on the AI and instead read and absorb the information yourself. thus, ahieving `R5`. <br/>
  ### ***Example:*** <br/>
  ```
  quartz search 'What is the binary layout of a descriptor in the x86_64 IDT?'
  ```
### `fetch`:
Displays all available statistics and information including: <br/>
  - habit stats: how many days left to reach each personal automaticity point per good habit and how many days left to destroy each bad habit. <br/>
  - *more to come...* <br/>
