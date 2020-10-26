/*
#include <iostream>
#include <string>
#include <zmq.hpp>

int main()
{
    zmq::context_t context(1);
    zmq::socket_t subscriber(context, ZMQ_SUB);
    subscriber.connect("tcp://localhost:5555");
    subscriber.setsockopt(ZMQ_SUBSCRIBE, "B", 1);

    while(true)
    {
        zmq::message_t env;
        subscriber.recv(&env);
        std::string env_str = std::string(static_cast<char*>(env.data()),
env.size()); std::cout << "Received envelope '" << env_str << "'" << std::endl;

        zmq::message_t msg;
        subscriber.recv(&msg);
        std::string msg_str = std::string(static_cast<char*>(msg.data()),
msg.size()); std::cout << "Received '" << msg_str << "'" << std::endl;
    }
    return 0;
}
*/

#include <future>
#include <iostream>
#include <string>
#include <zmq.hpp>
#include <zmq_addon.hpp>

void SubscriberThread3(zmq::context_t *ctx) {
  //  Prepare our context and subscriber
  zmq::socket_t subscriber(*ctx, zmq::socket_type::sub);
  subscriber.connect("inproc://#1");

  //  Thread3 opens ALL envelopes
  subscriber.set(zmq::sockopt::subscribe, "C");

  while (1) {
    // Receive all parts of the message
    std::vector<zmq::message_t> recv_msgs;
    zmq::recv_result_t result =
        zmq::recv_multipart(subscriber, std::back_inserter(recv_msgs));
    assert(result && "recv failed");

    std::cout << "SubscriberThread3: [" << recv_msgs[0] << "] " << recv_msgs[1]
              << std::endl;
  }
}

int main() {
  /*
   * No I/O threads are involved in passing messages using the inproc transport.
   * Therefore, if you are using a ØMQ context for in-process messaging only you
   * can initialise the context with zero I/O threads.
   *
   * Source: http://api.zeromq.org/4-3:zmq-inproc
   */

  zmq::context_t ctx(0);

  auto thread3 = std::async(std::launch::async, SubscriberThread3, &ctx);

  thread3.wait();
  /*
   * Output:
   *   An infinite loop of a mix of:
   *     Thread2: [A] Message in A envelope
   *     Thread2: [B] Message in B envelope
   *     Thread3: [A] Message in A envelope
   *     Thread3: [B] Message in B envelope
   *     Thread3: [C] Message in C envelope
   */
}
