import java.util.ArrayList;
import java.util.Scanner;

public class StudentGradeManager {
    private ArrayList<Student> students;
    private Scanner scanner;

    public StudentGradeManager() {
        students = new ArrayList<>();
        scanner = new Scanner(System.in);
    }

    public static void main(String[] args) {
        StudentGradeManager manager = new StudentGradeManager();
        manager.run();
    }

    public void run() {
        while (true) {
            printMenu();
            int choice = scanner.nextInt();
            scanner.nextLine(); // 清除缓冲区

            switch (choice) {
                case 1:
                    addStudent();
                    break;
                case 2:
                    addGrade();
                    break;
                case 3:
                    calculateAverage();
                    break;
                case 4:
                    displayAllStudents();
                    break;
                case 5:
                    findTopStudent();
                    break;
                case 6:
                    System.out.println("程序退出，谢谢使用！");
                    return;
                default:
                    System.out.println("无效选择，请重新输入。");
            }
        }
    }

    private void printMenu() {
        System.out.println("\n=== 学生成绩管理系统 ===");
        System.out.println("1. 添加学生");
        System.out.println("2. 添加成绩");
        System.out.println("3. 计算平均分");
        System.out.println("4. 显示所有学生");
        System.out.println("5. 查找最高分学生");
        System.out.println("6. 退出");
        System.out.print("请选择操作：");
    }

    private void addStudent() {
        System.out.print("请输入学生姓名：");
        String name = scanner.nextLine();
        System.out.print("请输入学生ID：");
        String id = scanner.nextLine();

        Student student = new Student(name, id);
        students.add(student);
        System.out.println("学生添加成功！");
    }

    private void addGrade() {
        if (students.isEmpty()) {
            System.out.println("暂无学生信息，请先添加学生。");
            return;
        }

        displayAllStudents();
        System.out.print("请选择学生序号：");
        int index = scanner.nextInt();

        if (index < 0 || index >= students.size()) {
            System.out.println("无效的学生序号！");
            return;
        }

        System.out.print("请输入科目：");
        scanner.nextLine();
        String subject = scanner.nextLine();
        System.out.print("请输入分数：");
        double score = scanner.nextDouble();

        students.get(index).addGrade(subject, score);
        System.out.println("成绩添加成功！");
    }

    private void calculateAverage() {
        if (students.isEmpty()) {
            System.out.println("暂无学生信息。");
            return;
        }

        for (Student student : students) {
            double average = student.calculateAverage();
            System.out.println(student.getName() + "的平均分：" + average);
        }
    }

    private void displayAllStudents() {
        if (students.isEmpty()) {
            System.out.println("暂无学生信息。");
            return;
        }

        System.out.println("\n=== 所有学生信息 ===");
        for (int i = 0; i < students.size(); i++) {
            System.out.println(i + ". " + students.get(i));
        }
    }

    private void findTopStudent() {
        if (students.isEmpty()) {
            System.out.println("暂无学生信息。");
            return;
        }

        Student topStudent = students.get(0);
        for (Student student : students) {
            if (student.calculateAverage() > topStudent.calculateAverage()) {
                topStudent = student;
            }
        }

        System.out.println("最高分学生：" + topStudent);
    }
}

class Student {
    private String name;
    private String id;
    private ArrayList<Grade> grades;

    public Student(String name, String id) {
        this.name = name;
        this.id = id;
        this.grades = new ArrayList<>();
    }

    public void addGrade(String subject, double score) {
        Grade grade = new Grade(subject, score);
        grades.add(grade);
    }

    public double calculateAverage() {
        if (grades.isEmpty()) return 0.0;

        double sum = 0;
        for (Grade grade : grades) {
            sum += grade.getScore();
        }
        return sum / grades.size();
    }

    public String getName() {
        return name;
    }

    public String getId() {
        return id;
    }

    @Override
    public String toString() {
        return "学生[姓名：" + name + ", ID：" + id + ", 平均分：" + calculateAverage() + "]";
    }
}

class Grade {
    private String subject;
    private double score;

    public Grade(String subject, double score) {
        this.subject = subject;
        this.score = score;
    }

    public String getSubject() {
        return subject;
    }

    public double getScore() {
        return score;
    }
}