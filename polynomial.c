#include "polynomial.h"

/* ================================================================== */
/*                       ВНУТРЕННИЕ УТИЛИТЫ                           */
/* ================================================================== */

static char* dupstr(const char* s) {
    if (!s) return NULL;
    size_t n = strlen(s) + 1;
    char* r = (char*)malloc(n);
    if (r) memcpy(r, s, n);
    return r;
}

/* ---------- Моном ---------- */

static Monomial* monomial_new(double coeff,
    char** vars, int* exps, int nvars) {
    Monomial* m = (Monomial*)malloc(sizeof(Monomial));
    if (!m) return NULL;
    m->coeff = coeff;
    m->nvars = nvars;
    m->next = NULL;
    m->vars = NULL;
    m->exps = NULL;
    if (nvars > 0) {
        m->vars = (char**)malloc(nvars * sizeof(char*));
        m->exps = (int*)malloc(nvars * sizeof(int));
        if (!m->vars || !m->exps) {
            free(m->vars); free(m->exps); free(m);
            return NULL;
        }
        for (int i = 0; i < nvars; i++) {
            m->vars[i] = dupstr(vars[i]);
            m->exps[i] = exps[i];
        }
    }
    return m;
}

static void monomial_free(Monomial* m) {
    if (!m) return;
    for (int i = 0; i < m->nvars; i++) free(m->vars[i]);
    free(m->vars);
    free(m->exps);
    free(m);
}

static void monomial_list_free(Monomial* m) {
    while (m) {
        Monomial* nx = m->next;
        monomial_free(m);
        m = nx;
    }
}

static int monomial_degree(const Monomial* m) {
    int d = 0;
    for (int i = 0; i < m->nvars; i++) d += m->exps[i];
    return d;
}

static int monomial_same_vars(const Monomial* a, const Monomial* b) {
    if (a->nvars != b->nvars) return 0;
    for (int i = 0; i < a->nvars; i++) {
        if (strcmp(a->vars[i], b->vars[i]) != 0) return 0;
        if (a->exps[i] != b->exps[i]) return 0;
    }
    return 1;
}

/* Сортировка: по убыванию суммарной степени, затем лексикографически */
static int monomial_cmp(const Monomial* a, const Monomial* b) {
    int da = monomial_degree(a);
    int db = monomial_degree(b);
    if (da != db) return db - da;
    int n = a->nvars < b->nvars ? a->nvars : b->nvars;
    for (int i = 0; i < n; i++) {
        int c = strcmp(a->vars[i], b->vars[i]);
        if (c != 0) return c;
        if (a->exps[i] != b->exps[i]) return b->exps[i] - a->exps[i];
    }
    return a->nvars - b->nvars;
}

/* ---------- Упрощение полинома ---------- */

static void poly_simplify(Polynomial* p) {
    if (!p) return;

    /* 1. Удалить нулевые */
    Monomial** pp = &p->terms;
    while (*pp) {
        if (fabs((*pp)->coeff) < 1e-12) {
            Monomial* dead = *pp;
            *pp = dead->next;
            monomial_free(dead);
        }
        else {
            pp = &(*pp)->next;
        }
    }

    /* 2. Объединить подобные */
    for (Monomial* a = p->terms; a; a = a->next) {
        Monomial** pp2 = &a->next;
        while (*pp2) {
            if (monomial_same_vars(a, *pp2)) {
                a->coeff += (*pp2)->coeff;
                Monomial* dead = *pp2;
                *pp2 = dead->next;
                monomial_free(dead);
            }
            else {
                pp2 = &(*pp2)->next;
            }
        }
    }

    /* 3. Ещё раз удалить нулевые */
    pp = &p->terms;
    while (*pp) {
        if (fabs((*pp)->coeff) < 1e-12) {
            Monomial* dead = *pp;
            *pp = dead->next;
            monomial_free(dead);
        }
        else {
            pp = &(*pp)->next;
        }
    }

    /* 4. Сортировка вставками по каноническому порядку */
    Monomial* sorted = NULL;
    Monomial* cur = p->terms;
    while (cur) {
        Monomial* nx = cur->next;
        if (!sorted || monomial_cmp(cur, sorted) < 0) {
            cur->next = sorted;
            sorted = cur;
        }
        else {
            Monomial* s = sorted;
            while (s->next && monomial_cmp(cur, s->next) >= 0) s = s->next;
            cur->next = s->next;
            s->next = cur;
        }
        cur = nx;
    }
    p->terms = sorted;
}

/* ================================================================== */
/*                    СОЗДАНИЕ / КОПИРОВАНИЕ                          */
/* ================================================================== */

Polynomial* create_zero(void) {
    Polynomial* p = (Polynomial*)malloc(sizeof(Polynomial));
    if (p) p->terms = NULL;
    return p;
}

Polynomial* create_constant(double c) {
    Polynomial* p = create_zero();
    if (!p) return NULL;
    if (fabs(c) > 1e-12) {
        p->terms = monomial_new(c, NULL, NULL, 0);
    }
    return p;
}

Polynomial* create_variable(const char* name) {
    Polynomial* p = create_zero();
    if (!p) return NULL;
    char* v[1] = { (char*)name };
    int   e[1] = { 1 };
    p->terms = monomial_new(1.0, v, e, 1);
    return p;
}

Polynomial* copy_polynomial(Polynomial* p) {
    if (!p) return NULL;
    Polynomial* r = create_zero();
    if (!r) return NULL;
    Monomial** tail = &r->terms;
    for (Monomial* m = p->terms; m; m = m->next) {
        Monomial* nm = monomial_new(m->coeff, m->vars, m->exps, m->nvars);
        *tail = nm;
        tail = &nm->next;
    }
    return r;
}

void free_polynomial(Polynomial* p) {
    if (!p) return;
    monomial_list_free(p->terms);
    free(p);
}

/* ================================================================== */
/*                      ПРОВЕРКИ / УТИЛИТЫ                            */
/* ================================================================== */

int is_zero(Polynomial* p) {
    return !p || !p->terms;
}

int is_constant(Polynomial* p, double* out) {
    if (!p || !p->terms || p->terms->next) return 0;
    if (p->terms->nvars != 0) return 0;
    if (out) *out = p->terms->coeff;
    return 1;
}

int is_monomial(Polynomial* p) {
    return p && p->terms && !p->terms->next;
}

int total_degree(Polynomial* p) {
    int d = 0;
    if (!p) return 0;
    for (Monomial* m = p->terms; m; m = m->next) {
        int md = monomial_degree(m);
        if (md > d) d = md;
    }
    return d;
}

/* ================================================================== */
/*                    СЛОЖЕНИЕ / ВЫЧИТАНИЕ                            */
/* ================================================================== */

static Polynomial* poly_add_signed(Polynomial* a, Polynomial* b, int sign) {
    Polynomial* r = copy_polynomial(a);
    if (!r) return NULL;
    Monomial** tail = &r->terms;
    while (*tail) tail = &(*tail)->next;
    for (Monomial* m = b->terms; m; m = m->next) {
        Monomial* nm = monomial_new(sign * m->coeff, m->vars, m->exps, m->nvars);
        *tail = nm;
        tail = &nm->next;
    }
    poly_simplify(r);
    return r;
}

Polynomial* add_polynomials(Polynomial* a, Polynomial* b) {
    if (!a) return copy_polynomial(b);
    if (!b) return copy_polynomial(a);
    return poly_add_signed(a, b, 1);
}

Polynomial* subtract_polynomials(Polynomial* a, Polynomial* b) {
    if (!a) return negate_polynomial(b);
    if (!b) return copy_polynomial(a);
    return poly_add_signed(a, b, -1);
}

Polynomial* negate_polynomial(Polynomial* p) {
    Polynomial* r = copy_polynomial(p);
    if (!r) return NULL;
    for (Monomial* m = r->terms; m; m = m->next) m->coeff = -m->coeff;
    return r;
}

/* ================================================================== */
/*                          УМНОЖЕНИЕ                                 */
/* ================================================================== */

static Monomial* monomial_mul(const Monomial* a, const Monomial* b) {
    int n = a->nvars + b->nvars;
    char** vars = (char**)malloc((n ? n : 1) * sizeof(char*));
    int* exps = (int*)malloc((n ? n : 1) * sizeof(int));
    int k = 0, i = 0, j = 0;
    while (i < a->nvars && j < b->nvars) {
        int c = strcmp(a->vars[i], b->vars[j]);
        if (c < 0) {
            vars[k] = (char*)a->vars[i]; exps[k] = a->exps[i]; k++; i++;
        }
        else if (c > 0) {
            vars[k] = (char*)b->vars[j]; exps[k] = b->exps[j]; k++; j++;
        }
        else {
            vars[k] = (char*)a->vars[i]; exps[k] = a->exps[i] + b->exps[j];
            k++; i++; j++;
        }
    }
    while (i < a->nvars) { vars[k] = (char*)a->vars[i]; exps[k] = a->exps[i]; k++; i++; }
    while (j < b->nvars) { vars[k] = (char*)b->vars[j]; exps[k] = b->exps[j]; k++; j++; }

    Monomial* m = monomial_new(a->coeff * b->coeff, vars, exps, k);
    free(vars); free(exps);
    return m;
}

Polynomial* multiply_polynomials(Polynomial* a, Polynomial* b) {
    if (!a || !b) return NULL;
    Polynomial* r = create_zero();
    if (!r) return NULL;
    Monomial** tail = &r->terms;
    for (Monomial* ma = a->terms; ma; ma = ma->next) {
        for (Monomial* mb = b->terms; mb; mb = mb->next) {
            Monomial* m = monomial_mul(ma, mb);
            *tail = m;
            tail = &m->next;
        }
    }
    poly_simplify(r);
    return r;
}

Polynomial* power_polynomial(Polynomial* p, int exp) {
    if (exp < 0) return NULL;
    if (exp == 0) return create_constant(1.0);
    Polynomial* r = copy_polynomial(p);
    for (int i = 1; i < exp; i++) {
        Polynomial* t = multiply_polynomials(r, p);
        free_polynomial(r);
        r = t;
    }
    return r;
}

/* ================================================================== */
/*                          ДЕЛЕНИЕ                                   */
/* ================================================================== */

/* Деление на ненулевую константу */
static Polynomial* div_by_const(Polynomial* a, double c) {
    Polynomial* r = copy_polynomial(a);
    if (!r) return NULL;
    for (Monomial* m = r->terms; m; m = m->next) m->coeff /= c;
    poly_simplify(r);
    return r;
}

/* Деление на моном (все члены делимого должны делиться нацело) */
static Polynomial* div_by_monomial(Polynomial* a, Monomial* d) {
    Polynomial* r = create_zero();
    if (!r) return NULL;
    Monomial** tail = &r->terms;

    for (Monomial* m = a->terms; m; m = m->next) {
        if (m->nvars < d->nvars) {
            fprintf(stderr, "Error: polynomial division is not exact\n");
            free_polynomial(r);
            return NULL;
        }
        int* newexp = (int*)malloc(m->nvars * sizeof(int));
        for (int i = 0; i < m->nvars; i++) newexp[i] = m->exps[i];

        int ok = 1;
        for (int i = 0; i < d->nvars && ok; i++) {
            int found = 0;
            for (int j = 0; j < m->nvars; j++) {
                if (strcmp(m->vars[j], d->vars[i]) == 0) {
                    newexp[j] -= d->exps[i];
                    if (newexp[j] < 0) ok = 0;
                    found = 1;
                    break;
                }
            }
            if (!found) ok = 0;
        }
        if (!ok) {
            free(newexp);
            fprintf(stderr, "Error: polynomial division is not exact\n");
            free_polynomial(r);
            return NULL;
        }

        /* Собираем оставшиеся переменные (с положительными степенями) */
        int n = 0;
        for (int i = 0; i < m->nvars; i++) if (newexp[i] > 0) n++;
        char** qvars = (char**)malloc((n ? n : 1) * sizeof(char*));
        int* qexps = (int*)malloc((n ? n : 1) * sizeof(int));
        int k = 0;
        for (int i = 0; i < m->nvars; i++) {
            if (newexp[i] > 0) {
                qvars[k] = m->vars[i];
                qexps[k] = newexp[i];
                k++;
            }
        }
        Monomial* nm = monomial_new(m->coeff / d->coeff, qvars, qexps, n);
        free(qvars); free(qexps); free(newexp);

        *tail = nm;
        tail = &nm->next;
    }
    poly_simplify(r);
    return r;
}

/* Возвращает имя единственной переменной, если полином одномерный
   (константа не считается одномерной — вернёт NULL и flag=0). */
static const char* univariate_var(Polynomial* p, int* found) {
    *found = 0;
    const char* v = NULL;
    for (Monomial* m = p->terms; m; m = m->next) {
        if (m->nvars > 1) return NULL;
        if (m->nvars == 1) {
            if (!v) v = m->vars[0];
            else if (strcmp(v, m->vars[0]) != 0) return NULL;
        }
    }
    if (v) *found = 1;
    return v;
}

/* Деление уголком для одномерных полиномов от одной переменной */
static Polynomial* div_univariate(Polynomial* a, Polynomial* b, const char* var) {
    int degA = 0, degB = 0;
    for (Monomial* m = a->terms; m; m = m->next) {
        int d = (m->nvars == 0) ? 0 : m->exps[0];
        if (d > degA) degA = d;
    }
    for (Monomial* m = b->terms; m; m = m->next) {
        int d = (m->nvars == 0) ? 0 : m->exps[0];
        if (d > degB) degB = d;
    }
    if (degA < degB) {
        fprintf(stderr, "Error: polynomial division gives zero quotient (deg A < deg B)\n");
        return NULL;
    }

    double* ca = (double*)calloc(degA + 1, sizeof(double));
    double* cb = (double*)calloc(degB + 1, sizeof(double));
    for (Monomial* m = a->terms; m; m = m->next) {
        int d = (m->nvars == 0) ? 0 : m->exps[0];
        ca[d] += m->coeff;
    }
    for (Monomial* m = b->terms; m; m = m->next) {
        int d = (m->nvars == 0) ? 0 : m->exps[0];
        cb[d] += m->coeff;
    }
    if (fabs(cb[degB]) < 1e-12) {
        fprintf(stderr, "Error: divisor has zero leading coefficient\n");
        free(ca); free(cb);
        return NULL;
    }

    double* q = (double*)calloc(degA - degB + 1, sizeof(double));
    double* r = (double*)calloc(degA + 1, sizeof(double));
    memcpy(r, ca, (degA + 1) * sizeof(double));

    for (int i = degA; i >= degB; i--) {
        if (fabs(r[i]) < 1e-12) continue;
        double coef = r[i] / cb[degB];
        int shift = i - degB;
        q[shift] = coef;
        for (int j = 0; j <= degB; j++) r[j + shift] -= coef * cb[j];
    }

    for (int i = 0; i < degB; i++) {
        if (fabs(r[i]) > 1e-9) {
            fprintf(stderr, "Error: polynomial division has non-zero remainder\n");
            free(ca); free(cb); free(q); free(r);
            return NULL;
        }
    }

    Polynomial* result = create_zero();
    Monomial** tail = &result->terms;
    for (int i = 0; i <= degA - degB; i++) {
        if (fabs(q[i]) < 1e-12) continue;
        Monomial* m;
        if (i == 0) {
            m = monomial_new(q[i], NULL, NULL, 0);
        }
        else {
            char* vv[1] = { (char*)var };
            int   ee[1] = { i };
            m = monomial_new(q[i], vv, ee, 1);
        }
        *tail = m;
        tail = &m->next;
    }
    poly_simplify(result);

    free(ca); free(cb); free(q); free(r);
    return result;
}

Polynomial* divide_polynomials(Polynomial* a, Polynomial* b) {
    if (!a || !b) return NULL;
    if (is_zero(b)) {
        fprintf(stderr, "Error: division by zero\n");
        return NULL;
    }
    if (is_zero(a)) return create_zero();

    /* 1. Деление на константу */
    double c;
    if (is_constant(b, &c)) {
        if (fabs(c) < 1e-12) {
            fprintf(stderr, "Error: division by zero\n");
            return NULL;
        }
        return div_by_const(a, c);
    }

    /* 2. Деление на моном */
    if (is_monomial(b)) {
        return div_by_monomial(a, b->terms);
    }

    /* 3. Унивариантное деление уголком */
    int foundB = 0;
    const char* varB = univariate_var(b, &foundB);
    if (!foundB) {
        fprintf(stderr,
            "Error: unsupported division "
            "(divisor is neither constant, monomial, nor univariate)\n");
        return NULL;
    }
    int foundA = 0;
    const char* varA = univariate_var(a, &foundA);
    if (foundA && strcmp(varA, varB) != 0) {
        fprintf(stderr,
            "Error: unsupported division (different variables '%s' and '%s')\n",
            varA, varB);
        return NULL;
    }

    return div_univariate(a, b, varB);
}

/* ================================================================== */
/*                       ПЕЧАТЬ ПОЛИНОМА                              */
/* ================================================================== */

void print_polynomial(Polynomial* p) {
    if (!p || !p->terms) {
        printf("0\n");
        return;
    }
    int first = 1;
    for (Monomial* m = p->terms; m; m = m->next) {
        double c = m->coeff;
        if (!first) {
            printf(c > 0 ? " + " : " - ");
            c = fabs(c);
        }
        else {
            if (c < 0) { printf("-"); c = -c; }
            first = 0;
        }
        if (m->nvars == 0) {
            printf("%g", c);
        }
        else {
            if (fabs(c - 1.0) > 1e-12) printf("%g*", c);
            for (int i = 0; i < m->nvars; i++) {
                if (i > 0) printf("*");
                if (m->exps[i] == 1) printf("%s", m->vars[i]);
                else printf("%s^%d", m->vars[i], m->exps[i]);
            }
        }
    }
    printf("\n");
}

/* ================================================================== */
/*                    ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ                           */
/* ================================================================== */

static GlobalVar* g_globals = NULL;

void set_variable(const char* name, Polynomial* poly) {
    for (GlobalVar* g = g_globals; g; g = g->next) {
        if (strcmp(g->name, name) == 0) {
            free_polynomial(g->poly);
            g->poly = copy_polynomial(poly);
            return;
        }
    }
    GlobalVar* g = (GlobalVar*)malloc(sizeof(GlobalVar));
    g->name = dupstr(name);
    g->poly = copy_polynomial(poly);
    g->next = g_globals;
    g_globals = g;
}

Polynomial* get_variable(const char* name) {
    for (GlobalVar* g = g_globals; g; g = g->next) {
        if (strcmp(g->name, name) == 0) return copy_polynomial(g->poly);
    }
    return NULL;
}

int is_defined(const char* name) {
    for (GlobalVar* g = g_globals; g; g = g->next)
        if (strcmp(g->name, name) == 0) return 1;
    return 0;
}