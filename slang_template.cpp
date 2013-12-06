/* Slang code
func int find_ele_pos(int ele)
{
  for (int i = 0; i < array_size; i++) {
     if(array[i] == ele){
        return i;
     }
  }
  return -1;
}

main()
{
  int array_size = 10;
  int array[array_size];
  int counter = 0;
  init
  {
    int i;
    #1 for (i = 0; i < array_size; i++ ){
        array[i] = array_size-i;
    }
    #25 Terminate;
  }
  always
  {
    #2 print(find_ele_pos(counter));
    counter++;
  }
}
*/
// preprocessor directives
#include <iostream>
#include <string>
#include <deque>
#include <vector>
#include <cstdlib> // because gcc 4.3 is why
// inherited base class
struct event_{
    unsigned int time;
    virtual unsigned int get_time(){};
    virtual void foo(){};
    virtual ~event_(){};
};
// event queue, this struct is optional, we could have functions do the event.add
struct event_q_ {
    //if event_q is private member, this function is needed
    bool empty(){return event_q.empty();}
    //if event_q is private memeber, this function is needed
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
//declaring global event queue
event_q_ event_q;

// global variable declartions, prefix required for global scope, I used u_
// NOTE:  I think that user object declarations in our slang file should be placed
//        here also.  They would be stored as structs first with the name u_[id]
//        ie: object dog = object (string name = "bob)
//            would be struct u_dog with member string name;
int u_array_size = 10;
std::vector<int> u_array(u_array_size);
int u_counter = 0;

// function declarations, all should have some prefix for global scoped, I used u_
int u_find_ele_pos(int u_ele)
{
    for (int u_i = 0; u_i < u_array_size; u_i++)
    {
        if (u_array[u_i] == u_ele)
        {
            return u_i;
        }
    }
    return -1;
}

// *EDIT*  Read always blocks comments for updated init blocks
// time blocks
//   init blocks should just inherit event_
//   Note: the prefixes for the init
//         as well as the init block structures
//         need to be stored somewhere for future
//         when we create the objects in main
//  we need a variable declartion list stored in ocaml for init block code
//  this example only has 1 declartion
int init1_i;
unsigned int init1_time = 0;
struct init1_link_ : public event_ {
    virtual void set_next(init1_link_ *n){};
};
std::vector<init1_link_*> init1_list;
//  blocks contain all code between # delays and braces
//  I used function foo as the name, but we could use any
//  all code aside from variable declaration is found in each struct's foo
struct init1_block1_ : public init1_link_ {
    unsigned int time;
    init1_block1_() : time(0){}
    unsigned int get_time(){return time;};
    init1_link_ *next;
    void set_next(init1_link_ *n){next = n;}
    void foo(){
        // nothing before #2 print(find_ele_pos(counter))
        // so just puts next struct on list
        // whenever an always foo() is called, it puts it's
        // next object pointed to on the list
        init1_time += next->get_time();
        event_q.add(init1_time, next);
    }
};
struct init1_block2_ : public init1_link_ {
    unsigned int time;
    init1_block2_() : time(1){}
    unsigned int get_time(){return time;};
    init1_link_ *next;
    void set_next(init1_link_ *n){next = n;}
    void foo(){
        // notice that we need to keep track of scope.
        // since init1_array_size and init1_array does not exist, then
        // those variables are not within the scope of this init block
        // and must be in main, which would add a u_ prefix instead of init1_
        for (init1_i = 0; init1_i < u_array_size; init1_i++)
        {
            u_array[init1_i] = u_array_size-init1_i;
        }
        init1_time += next->get_time();
        event_q.add(init1_time, next);
    }
};
struct init1_block3_ : public init1_link_ {
    unsigned int time;
    init1_block3_() : time(25){}
    unsigned int get_time(){return time;};
    init1_link_ *next;
    void set_next(init1_link_ *n){next = n;}
    void foo(){
        // exit to Terminate, any objections?
        exit(0);
        init1_time += next->get_time();
        event_q.add(init1_time, next);
    }
};

// always blocks
//   time is kept in mind for all blocks of the same always
//   the vector is used later for making each element's next
//   pointer point to the next block
//   NOTE:  I see prefixes that need to be stored here is
//          the always block (always1_) since that is used
//          within all the always1_ block structures. Each
//          block structure would also need to be stored somewhere
//          so we can declare objects for them and store those objects
//          in the always1_list
//  variable declaration list
//    v_decl should be here if any existed, but don't in this example
//  essential declarations, this stuff should be the same with the prefix
//  for the always blocks changing
unsigned int always1_time = 0;
struct always1_link_ : public event_ {
    virtual void set_next(always1_link_ *n){};
};
std::vector<always1_link_*> always1_list;
struct always1_block1_ : public always1_link_ {
    unsigned int time;
    always1_block1_() : time(0){}
    unsigned int get_time(){return time;};
    always1_link_ *next;
    void set_next(always1_link_ *n){next = n;}
    void foo(){
        // nothing before #2 print(find_ele_pos(counter))
        // so just puts next struct on list
        // whenever an always foo() is called, it puts it's
        // next object pointed to on the list
        always1_time += next->get_time();
        event_q.add(always1_time, next);
    }
};
struct always1_block2_ : public always1_link_ {
    unsigned int time;
    always1_block2_() : time(2){}
    unsigned int get_time(){return time;};
    always1_link_ *next;
    void set_next(always1_link_ *n){next = n;}
    void foo(){
        // not sure how we wish to handle print, if it println or not
        std::cout << u_find_ele_pos(u_counter) << std::endl;
        u_counter++;
        always1_time += next->get_time();
        event_q.add(always1_time, next);
    }
};

// Each init and always blocks should have code that looks like what is below
// the only differences would be the prefixes, ie init1_, init2_, always1_, always2_
int main()
{
    /* OUTDATED
    // Init block object declartions for event q
    //  initiate init struct objects and add to event q afterwards.
    //  we could have a list of structs starting with "init" in ocaml
    //  and create objects for each of them and store each object
    init1_block1_ init1_block1_obj;
    event_q.add(init1_block1_obj.get_time(), &init1_block1_obj);
    init1_block2_ init1_block2_obj;
    event_q.add(init1_block2_obj.get_time(), &init1_block2_obj);
    init1_block3_ init1_block3_obj;
    event_q.add(init1_block3_obj.get_time(), &init1_block3_obj);
    */
    // Init blocks now act like always blocks
    init1_block1_ init1_block1_obj;
    init1_list.push_back(&init1_block1_obj);
    init1_block2_ init1_block2_obj;
    init1_list.push_back(&init1_block2_obj);
    init1_block3_ init1_block3_obj;
    init1_list.push_back(&init1_block3_obj);
    // Same as always block, except if last block, don't go back to
    for (int i = 0; i < init1_list.size(); i++)
    {
        if (i != init1_list.size()-1)
            init1_list[i]->set_next(init1_list[i+1]);
        else
            init1_list[i]->set_next(NULL);
    }
    event_q.add(init1_block1_obj.get_time(), &init1_block1_obj);
    // Always block object declarations for event q
    //  create each always block, and for each always,
    //  we take the blocks associated with it and add it to a list
    always1_block1_ always1_block1_obj;
    always1_list.push_back(&always1_block1_obj);
    always1_block2_ always1_block2_obj;
    always1_list.push_back(&always1_block2_obj);
    //  for each always block list, we create a circular list
    //  with each always block object pointing to the next
    //  object, and the last object points to the first
    for (int i = 0; i < always1_list.size(); i++)
    {
        if (i != always1_list.size()-1)
            always1_list[i]->set_next(always1_list[i+1]);
        else
            always1_list[i]->set_next(always1_list[0]);
    }
    //  for always blocks, we want to only add to the event q
    //  objects that end in "block1_obj" since that is the start
    //  of an always
    event_q.add(always1_block1_obj.get_time(), &always1_block1_obj);

    //loop through event q while it's not still empty
    while(!event_q.empty()) {
        event_q.pop()->foo();
    }
    return 0;
}
