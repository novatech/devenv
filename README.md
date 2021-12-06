portable nvim container that i just pull use anywhere

    docker build -t azwan/devenv:rhel .
    docker run -it --rm -v $(pwd):/work azwan/devenv:rhel

