FROM debian:bookworm AS build-stage

RUN apt-get update \
    && apt-get install -y build-essential git clang libasound2-dev \
    libx11-dev libxrandr-dev libxi-dev libgl1-mesa-dev libglu1-mesa-dev \
    libxcursor-dev libxinerama-dev xxd libglfw3-dev mingw-w64 mingw-w64-tools \
    pandoc zip wget imagemagick chicken-bin \
    texlive-base texlive-binaries texlive-fonts-recommended \
    texlive-latex-base texlive-latex-extra texlive-latex-recommended \
    texlive-luatex texlive-pictures texlive-plain-generic \
    texlive-xetex

RUN git clone --branch 4.5.0 --depth 1 https://github.com/raysan5/raylib
WORKDIR "/raylib/src"
RUN make
RUN make install

WORKDIR "/"

RUN git clone https://github.com/lispunion/code-formatter
WORKDIR "/code-formatter"
RUN  chicken-install -from-list dependencies.txt \
    && ./build.sh \
    && cp scheme-format /usr/bin/

WORKDIR "/"

RUN git clone https://github.com/krzysckh/msc2023
WORKDIR "/msc2023"
RUN make
RUN cp main ../msc2023-lambda-optyka-linux-x86_64
RUN make build-windows WINDRES=llvm-windres-14
RUN cp rl-optyka-test.exe ../msc2023-lambda-optyka-win64.exe
RUN mkdir -p /usr/share/fonts \
    && wget https://pub.krzysckh.org/_fonts/lg/LucidaGrande-Regular.otf \
      -O /usr/share/fonts/LucidaGrande-Regular.otf \
    && wget https://pub.krzysckh.org/_fonts/lg/LucidaGrande-Bold.otf \
      -O /usr/share/fonts/LucidaGrande-Bold.otf \
    && wget https://pub.krzysckh.org/_fonts/lg/LucidaGrande-Italic.otf \
      -O /usr/share/fonts/LucidaGrande-Italic.otf \
    && wget https://pub.krzysckh.org/_fonts/lg/LucidaGrande-BoldItalic.otf \
      -O /usr/share/fonts/LucidaGrande-BoldItalic.otf \
    && wget https://pub.krzysckh.org/_fonts/Apl385.ttf \
      -O /usr/share/fonts/Apl385.ttf \
    && fc-cache -fv
RUN make dist WINDRES=llvm-windres-14
RUN cp msc2023-dist.zip ../ && cp msc2023-dist.tgz ../
