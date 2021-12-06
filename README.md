portable nvim container that i can just pull and use anywhere

    docker build -t azwan/devenv:rhel .
    docker run -it --rm -v $(pwd):/work azwan/devenv:rhel

