#include "line.h"

/* Constructor */
Line::Line() {
    p1 = Point();
    p2 = Point();
}
Line::Line(const Point &p1, const Point &p2) {
    this->p1 = p1;
    this->p2 = p2;
}
Line::Line(const Line &l) {
    p1 = l.getP1();
    p2 = l.getP2();
}

/* Destructor */
Line::~Line() {
}

/* Getters */
Point Line::getP1() const {
    return p1;
}
Point Line::getP2() const {
    return p2;
}
std::ostream &operator<<(std::ostream &os, const Line &l) {
    os << std::fixed << std::setprecision(4) << l.getP1() << " -- " << l.getP2();
    return os;
}

/* Setters */
void Line::setP1(const Point &p1) {
    this->p1 = p1;
}
void Line::setP2(const Point &p2) {
    this->p2 = p2;
}
void Line::setPoints(const Point &p1, const Point &p2) {
    this->p1 = p1;
    this->p2 = p2;
}
std::istream &operator>>(std::istream &is, Line &l) {
    Point p1, p2;
    is >> p1 >> p2;
    l.setPoints(p1, p2);
    return is;
}

/* Functions */
double Line::length() const {
    // Return the length of the line
    Point p1 = this->getP1();
    Point p2 = this->getP2();
    return p1.distance(p2);
}
double Line::slope() const {
    // Return the slope of the line
    Point p1 = this->getP1();
    Point p2 = this->getP2();

    if (p2.getX() == p1.getX()) {
        return INFINITY;
    } else {
        return (p2.getY() - p1.getY()) / (p2.getX() - p1.getX());
    }
}
