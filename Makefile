BUILD_DIR=build

CC = gcc
CFLAGS = -Wall -g
INCLUDES = 
LFLAGS = 
LIBS = 

SRCS = src/reset.c

OBJS = $(SRCS:.c=.o)

TARGET = $(BUILD_DIR)/reset

.PHONY: default

default: $(OBJS) 
	mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) $(INCLUDES) -o $(TARGET) $(OBJS) $(LFLAGS) $(LIBS)

# this is a suffix replacement rule for building .o's from .c's
# it uses automatic variables $<: the name of the prerequisite of
# the rule(a .c file) and $@: the name of the target of the rule (a .o file) 
# (see the gnu make manual section about automatic variables)
.c.o:
	$(CC) $(CFLAGS) $(INCLUDES) -c $<  -o $@

clean:
	$(RM) src/*.o src/*~ $(MAIN)

install:
	cp systemd/reset.service /lib/systemd/system/
	cp $(TARGET) /usr/local/bin/reset
	systemctl start reset.service
	systemctl enable reset.service

uninstall:
	systemctl stop reset.service
	systemctl disable reset.service
	rm /usr/local/bin/reset
	rm /lib/systemd/system/reset.service