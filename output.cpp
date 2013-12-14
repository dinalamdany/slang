#include <iostream>
#include <string>
#include <deque>
#include <vector>
#include <cstdlib>
struct event_ {
	unsigned int time;
	virtual unsigned int get_time() {};
	virtual void foo() {};
	virtual ~event_() {};
};
struct event_q_ {
	bool empty() {return event_q.empty();}
	event_* pop() {
		event_ *front = event_q.front();
		event_q.pop_front();
		return front;
	}
	void add(unsigned int time_, event_ *obj_) {
		bool eol = true;
		std::deque<event_*>::iterator it;
		if (obj_ == NULL)
			return;
		for (it = event_q.begin(); it != event_q.end(); it++) {
			if ((*it)->get_time() > time_) {
				event_q.insert(it, obj_);
				eol = false;
				break;
			}
		}
		if (eol) {
			event_q.push_back(obj_);
		}
	}
	private:
		std::deque<event_*> event_q;
};
event_q_ event_q;

int u_a;
void u_bar() {
std::cout << u_a;
}
unsigned int init_0_time = 0;
struct init_0_link_ : public event_ {
	virtual void set_next(init_0_link_ *n){};
};
std::vector<init_0_link_*> init_0_list;
struct init_0_block_0 : public init_0_link_ {
	unsigned int time;
	init_0_block_0() : time(0) {}
	unsigned int get_time() {return time;}
	init_0_link_ *next;
	void set_next(init_0_link_ *n) {next = n;};
	void foo() {
	
	init_0_time += next->get_time();
	event_q.add(init_0_time, next);
	}
};

int main() {
	init_0_block_0 init_0_block_0obj;
	init_0_list.push_back(&init_0_block_0obj);
	for (int i = 0; i < init_0_list.size(); i++)
	{
		if (i != init_0_list.size()-1)
			init_0_list[i]->set_next(init_0_list[i+1]);
		else
			init_0_list[i]->set_next(NULL);
	}
u_a = 10;
u_bar();
while(!event_q.empty()) {
	event_q.pop()->foo();
	}
return 0;
}
