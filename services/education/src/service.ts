let courses: any[] = [];
let enrollments: any[] = [];
let courseId = 1;

export async function addCourse(instructor: string, course: any) {
  const id = courseId++;
  courses.push({ id, instructor, ...course });
  return { id, status: "added" };
}

export async function enrollStudent(student: string, courseId: number) {
  const course = courses.find(c => c.id === courseId);
  if (!course) return { error: "course not found" };
  enrollments.push({ student, courseId });
  return { student, courseId, status: "enrolled" };
}

export async function getCourses() {
  return courses;
}