#include "triangle.h"

/* Constructor */
Triangle::Triangle() {
    p1 = Point();
    p2 = Point();
    p3 = Point();
}
Triangle::Triangle(const Point &p1, const Point &p2, const Point &p3) {
    this->p1 = p1;
    this->p2 = p2;
    this->p3 = p3;
}
Triangle::Triangle(const Triangle &t) {
    p1 = t.getP1();
    p2 = t.getP2();
    p3 = t.getP3();
}

/* Destructor */
Triangle::~Triangle() {
}

/* Getters */
Point Triangle::getP1() const {
    return p1;
}
Point Triangle::getP2() const {
    return p2;
}
Point Triangle::getP3() const {
    return p3;
}
std::ostream &operator<<(std::ostream &os, const Triangle &t) {
    os << std::fixed << std::setprecision(4) << t.getP1() << " -- " << t.getP2() << " -- " << t.getP3();
    return os;
}

/* Setters */
void Triangle::setP1(const Point &p1) {
    this->p1 = p1;
}
void Triangle::setP2(const Point &p2) {
    this->p2 = p2;
}
void Triangle::setP3(const Point &p3) {
    this->p3 = p3;
}
void Triangle::setPoints(const Point &p1, const Point &p2, const Point &p3) {
    this->p1 = p1;
    this->p2 = p2;
    this->p3 = p3;
}
std::istream &operator>>(std::istream &is, Triangle &t) {
    Point p1, p2, p3;
    is >> p1 >> p2 >> p3;
    t.setPoints(p1, p2, p3);
    return is;
}

/* Functions */
double Triangle::perimeter() const {
    // Return the perimeter of the triangle
    Point p1 = this->getP1();
    Point p2 = this->getP2();
    Point p3 = this->getP3();
    return p1.distance(p2) + p2.distance(p3) + p3.distance(p1);
    return 0;
}
double Triangle::area() const {
    // Return the area of the triangle
    Point p1 = this->getP1();
    Point p2 = this->getP2();
    Point p3 = this->getP3();
    double a = p1.distance(p2);
    double b = p2.distance(p3);
    double c = p3.distance(p1);
    double s = (a + b + c) / 2;
    return sqrt(s * (s - a) * (s - b) * (s - c));
}
