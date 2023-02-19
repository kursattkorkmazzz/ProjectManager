//
//  ProjecViewModel.swift
//  Project Manager
//
//  Created by Kursat Korkmaz on 15.02.2023.
//

import Foundation

class ProjectViewModel : ObservableObject{
    @Published var projects : [Project] = [Project(name: "Project Example 1 Name", description: "Description example for",todos: []),
                                           Project(name: "Project Example 2 Name", description: "Description example for example project 2",todos: []),
                                           Project(name: "Project Example 3 Name", description: "Description example for example project 3",todos: [])]
    
    init() {
        projects[0].todos.append(Todo(title: "İlk Yapılacak Şey", description: "Yapılacak şeyi açıklayan yazı.", status: .ToDo))
        projects[0].todos.append(Todo(title: "İkinci Yapılacak Şey", description: "İkinci Yapılacak şeyi açıklayan yazı.", status: .ToDo))
    }
    
    
    
    // Creates projects.
    func createProject(project : Project) throws -> Bool{
        
        if !isExistProject(project: project){
            
            if !project.name.isEmpty{
                projects.append(project)
                return true
            }
            throw ProjectErrors.ProjectNameCannotBeNull
        }else{
            throw ProjectErrors.AlreadyExistError
        }
    }
    
    // Delete projects.
    func deleteProject(project : Project) throws -> Bool{
        if isExistProject(project: project){
            for (index,elem) in projects.enumerated(){
                if elem.id == project.id{
                    projects.remove(at: index)
                }
            }
            return true
        }else{
            throw ProjectErrors.ProjectNotFound
        }
    }
    
    // Edit projects.
    func editProject(project : Project) throws -> Bool{
        if isExistProject(project: project){
            for (index,elem) in projects.enumerated(){
                if elem.id == project.id{
                    projects[index].name = project.name
                    projects[index].description = project.description
                }
            }
            return true
        }else{
            throw ProjectErrors.ProjectNotFound
        }
    }
    
    // Gets project with same ID
    
    
    //Checks if exist project with same id with [project]
    private func isExistProject(project : Project) -> Bool {
        
        if projects.contains(where: {$0.id == project.id}){
            // print("BULUNDU.")
            return true
        }
        // print("YOH BULUNAMADI.")
        return false
    }
    
    
    // Checks and returns true if [todo] is exist in [project], oherwise false.
    private func isExistTodo(project : Project, todo: Todo) -> Bool{
        if project.todos.contains(where: {$0.id == todo.id}){
            return true
        }
        return false
    }
    
    // Edit todo in specified project
    func editTodo(project: Project, todo: Todo) throws{
        if isExistProject(project: project){
            if isExistTodo(project: project, todo: todo){
                
                for (index,project_elem) in projects.enumerated(){
                    if project_elem.id == project.id{
                        for (todo_index,todo_elem) in projects[index].todos.enumerated(){
                            if todo_elem.id == todo.id{
                                projects[index].todos[todo_index].title = todo.title
                                projects[index].todos[todo_index].description = todo.description
                                projects[index].todos[todo_index].status = todo.status
                            }
                        }
                    }
                }
                
            }else{
                throw TodoErrors.TodoNotFound
            }
        }else{
            throw ProjectErrors.ProjectNotFound
        }
    }
    
    
    // Deletes [todo] in [project].
    func deleteTodo(project: Project, todo: Todo) throws -> Bool{
        if isExistProject(project: project){
            if isExistTodo(project: project, todo: todo){
                for (project_index, project_elem) in self.projects.enumerated(){
                    for (todo_index, todo_elem) in projects[project_index].todos.enumerated(){
                        if (project_elem.id == project.id && todo_elem.id == todo.id){
                            projects[project_index].todos.remove(at: todo_index)
                            return true
                        }
                    }
                }
                return false
            }else{
                throw TodoErrors.TodoNotFound
            }
        }else{
            throw ProjectErrors.ProjectNotFound
        }
    }
    
    // Change status next one. To Do -> In Progress -> Done
    func forwardStatus(project : Project, todo : Todo) throws{
        if isExistProject(project: project){
            if isExistTodo(project: project, todo: todo){
                for (project_index, project_elem) in projects.enumerated(){
                    for (todo_index, todo_elem) in projects[project_index].todos.enumerated(){
                        if(project_elem.id == project.id && todo_elem.id == todo.id){
                            switch projects[project_index].todos[todo_index].status{
                            case .ToDo:
                                projects[project_index].todos[todo_index].status = .InProgress
                            case .InProgress:
                                projects[project_index].todos[todo_index].status = .Done
                            default:
                                return
                            }
                        }
                    }
                }
            }else{
                throw TodoErrors.TodoNotFound
            }
        }else{
            throw ProjectErrors.ProjectNotFound
        }
    }
    
    
    
    
    // Change status previous one. Done -> In Progress -> To Do
    func previousStatus(project : Project, todo : Todo) throws{
        if isExistProject(project: project){
            if isExistTodo(project: project, todo: todo){
                for (project_index, project_elem) in projects.enumerated(){
                    for (todo_index, todo_elem) in projects[project_index].todos.enumerated(){
                        if(project_elem.id == project.id && todo_elem.id == todo.id){
                            switch projects[project_index].todos[todo_index].status{
                            case .Done:
                                projects[project_index].todos[todo_index].status = .InProgress
                            case .InProgress:
                                projects[project_index].todos[todo_index].status = .ToDo
                            default:
                                return
                            }
                        }
                    }
                }
            }else{
                throw TodoErrors.TodoNotFound
            }
        }else{
            throw ProjectErrors.ProjectNotFound
        }
    }
    
   
    // Change status previous one. Done -> In Progress -> To Do
    func done(project : Project, todo : Todo) throws{
        if isExistProject(project: project){
            if isExistTodo(project: project, todo: todo){
                for (project_index, project_elem) in projects.enumerated(){
                    for (todo_index, todo_elem) in projects[project_index].todos.enumerated(){
                        if(project_elem.id == project.id && todo_elem.id == todo.id){
                            projects[project_index].todos[todo_index].status = .Done
                        }
                    }
                }
            }else{
                throw TodoErrors.TodoNotFound
            }
        }else{
            throw ProjectErrors.ProjectNotFound
        }
    }
    
    // Create new [todo] and add to [project]
    func createTodo(project : Project, todo : Todo) throws{
        if isExistProject(project: project){
            for (project_index, project_elem) in projects.enumerated(){
                if (project_elem.id == project.id && todo.id != nil && !todo.title.isEmpty){
                    projects[project_index].todos.append(todo)
                    return
                }
            }
        }else{
            throw ProjectErrors.ProjectNotFound
        }
    }
    
    static var emptyProject : Project{
        return Project(name: "", description: "",todos: [])
    }
    
}
