CXXFLAGS = -O3 -std=c++2a

.PHONY: all clean elf docker

all: game

main.o: main.cc instructions.hh execute.hh mmap.hh
	$(CXX) $(CXXFLAGS) -c main.cc -o main.o

game: main.o
	$(CXX) -o game $(CXXFLAGS) main.o

game.elf: main.cc instructions.hh execute.hh mmap.hh
	$(CXX) -o game.elf $(CXXFLAGS) main.cc

docker: main.cc
	@docker run --rm -w /app -v "$(shell pwd):/app" -it kanav99/gba make game.elf

clean:
	rm -f *.o game *.elf

venv:
	@python3 -m venv venv
	@VIRTUAL_ENV=./venv venv/bin/pip install -U pip
	@VIRTUAL_ENV=./venv venv/bin/pip install -r requirements.txt

disas: docker venv
	@VIRTUAL_ENV=./venv venv/bin/python minidis.py

