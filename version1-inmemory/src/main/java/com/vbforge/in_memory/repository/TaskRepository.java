package com.vbforge.in_memory.repository;

import com.vbforge.in_memory.model.Task;
import org.springframework.stereotype.Repository;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

@Repository
public class TaskRepository {

    private final Map<Long, Task> tasks = new ConcurrentHashMap<>();
    private long nextId = 1;

    public List<Task> findAll() {
        return new ArrayList<>(tasks.values());
    }

    public List<Task> findAll(boolean completed) {
        return tasks.values().stream()
                .filter(task -> task.isCompleted() == completed)
                .collect(Collectors.toList());
    }

    public Optional<Task> findById(Long id) {
        return Optional.ofNullable(tasks.get(id));
    }

    public Task save(Task task) {
        if (task.getId() == null) {
            task.setId(nextId++);
        }
        tasks.put(task.getId(), task);
        return task;
    }

    public void delete(Long id) {
        tasks.remove(id);
    }

    public boolean existsById(Long id) {
        return tasks.containsKey(id);
    }
}