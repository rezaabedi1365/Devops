# Docker Network Cheat-sheet
### Type of network Driver in Docker
  •  Bridge       
		○ #docker run –dit ubuntu  (it is default and container get ip to host range)
		○ #docker run –dit  - - network nework1 ubuntu      (you catn create newtork and assign different range ip )  

	•  Host           running container exactly mapped on the host     
		○ #docker run –dit  -- network host  ubuntu
	• None
	• Overlay
Macvlan  (physical NIC )![image](https://github.com/rezaabedi1365/Devops/assets/117336743/db0f69a5-40ba-46a9-a3df-0afe679d32f7)



```
FROM ruby:2.2.2

WORKDIR /myapp

ADD file.xyz /file.xyz
COPY --chown=user:group host_file.xyz /path/container_file.xyz

EXPOSE 5900

VOLUME ["/data"]

CMD    ["bundle", "exec", "rails", "server"]

```
