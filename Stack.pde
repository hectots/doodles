// Stack
// Simple stack data structure.

class Stack<T> {
  ArrayList<T> items;

  Stack() {
    items = new ArrayList<T>();
  }

  void push(T item) {
    items.add(item);
  }

  T pop() {
    if (items.size() == 0) return null;

    T topItem = items.get(items.size() - 1);
    items.remove(items.size() - 1);
    return topItem;
  }

  T peek() {
    if (items.size() == 0) return null;

    T topItem = items.get(items.size() - 1);
    return topItem;
  }

  int size() {
    return items.size();
  }
}