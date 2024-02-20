.PHONY: all rm-container clean get

DOCKER=sudo docker

all: rm-container
	$(DOCKER) build -t msc2023 .
	$(DOCKER) run -d --name msc2023-c msc2023
	$(MAKE) get thing=msc2023-dist.tgz
	$(MAKE) get thing=msc2023-dist.zip
	$(MAKE) get thing=msc2023-lambda-optyka-linux-x86_64
	$(MAKE) get thing=msc2023-lambda-optyka-win64.exe

clean:
	rm -f msc2023-dist.tgz \
		msc2023-dist.zip \
		msc2023-lambda-optyka-linux-x86_64 \
		msc2023-lambda-optyka-win64.exe

rm-container:
	$(DOCKER) rm msc2023-c || echo ok

get:
	$(DOCKER) container cp msc2023-c:/$(thing) $(thing)
