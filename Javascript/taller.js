//Tipos
    //Bool
    Bool = {}
    Bool.toString = function(){return "Bool"}
    Bool.deepCopy = function(){return this}

    //Flecha
    Flecha = function(a,b){
        this.A = a
        this.B = b
    }
    Flecha.prototype.toString = function(){return "(" + this.A.toString() + " -> " + this.B.toString() + ")"}
    Flecha.prototype.deepCopy = function(){
        return new Flecha(this.A.deepCopy(),this.B.deepCopy())
    }

//Terminos
    //TRUE
    TT = {}
    TT.toString = function(){return "true"}
    TT.deepCopy = function(){return this}
    TT.sust = function(x,m){return this}

    //FALSE
    FF = {}
    FF.toString = function(){return "false"}
    FF.deepCopy = function(){return this}
    FF.sust = function(x,m){return this}

    //VAR
    X = function(s){
        this.X = s
    }
    X.prototype.toString = function(){return this.X}
    X.prototype.deepCopy = function(){
        return new X(this.X)
    }

    X.prototype.sust = function(x,m){
        if(this.X == x){
            res = m    
        }else{
            res = this.X    
        }
        return res
    }
    

    //APP
    app = function(m,n){
        this.M = m
        this.N = n
    }
    app.prototype.toString = function(){return "(" + this.M.toString() + " " + this.N.toString() + ")"}
    app.prototype.deepCopy = function(){
        return new app(this.M.deepCopy(),this.N.deepCopy())
    }
    app.prototype.sust = function(x,m){
        return new app(this.M.sust(x,m),this.N.sust(x,m))
    }
    app.prototype.reducir = function(){
            if (this.M.hasOwnProperty('reducir')){
                return this.M = this.M.reducir()            
            }
            if (this.N.hasOwnProperty('reducir')){
                return this.N = this.N.reducir()
            }
            sustituido = this.M.M.sust(this.M.X, this.N)
            if (sustituido.hasOwnProperty('reducir')){
                return sustituido   
            }else{
                return sustituido
            }
    }

    //ABS
    abs = function(x,a,m){
        this.X = x
        this.A = a
        this.M = m
    }
    abs.prototype.toString = function(){
        return "\\" + this.X + ":" + this.A.toString() + "." + this.M.toString()}
    abs.prototype.deepCopy = function(){
        return new abs(this.A.deepCopy(),this.M.deepCopy())
    }
    abs.prototype.sust = function(y,m){
        if(y == this.X){
            res = this
        }else{
            res = new abs(this.X,this.A,this.M.sust(y,m))
        }
        return res
    }

//Inicializo cosas para tests
term = new abs("x",new Flecha(new Flecha(Bool,Bool),Bool),new app(new X("x"),TT))
term2 = new abs("y",new Flecha(new Flecha(Bool,Bool),Bool),new app(new X("x"),TT))
term3 = new abs("x",Bool,TT)
fB = new Flecha(Bool,Bool)
x = new X("x")
z = new X("z")
term4 = new abs("x",Bool,x)
term5 = new abs("y",Bool,x)
term6 = new app(new abs ("x",Bool,x), TT)
term7 = new app(new abs("z", Bool,z), (new abs ("x",Bool,x), TT))

console.log("Tests toString() ej 2")
console.log(Bool.toString() == "Bool")
console.log(term3.toString() == "\\x:Bool.true")
console.log(term.toString() == "\\x:((Bool -> Bool) -> Bool).(x true)")
console.log(term2.toString() == "\\y:((Bool -> Bool) -> Bool).(x true)")

console.log("Tests toString() ej 3")
console.log(Bool.deepCopy() == Bool)
console.log(x.deepCopy() != x.deepCopy)
console.log(fB.deepCopy() != fB.deepCopy)
console.log(term.deepCopy() != term)

console.log("Tests sust(x,m) ej 4")
console.log((TT.sust("x",TT)).toString() == "true")
console.log((FF.sust("x",FF)).toString() == "false")
console.log((x.sust("x",FF)).toString() == "false")
console.log((x.sust("y",FF)).toString() == "x")
//console.log((term.sust("x",FF)).toString() == "\\x:((Bool -> Bool) -> Bool).(false true)")
console.log((term3.sust("x",FF)).toString() == "\\x:Bool.true")
console.log((term4.sust("y",FF)).toString() == "\\x:Bool.x")
console.log((term5.sust("x",FF)).toString() == "\\y:Bool.false")
console.log((term5.sust("x",new X("p"))).toString() == "\\y:Bool.p")
console.log((term5.sust("x",term4)).toString() == "\\y:Bool.\\x:Bool.x")
console.log(term.sust("x",FF).toString() == "\\x:((Bool -> Bool) -> Bool).(x true)")
console.log(term2.sust("x",FF).toString() == "\\y:((Bool -> Bool) -> Bool).(false true)")
console.log((term3.sust("x",FF)).toString() == "\\x:Bool.true")

//prueba de reduccion
console.log("Prueba de reduccion")
console.log(term6.reducir().toString() == "true")
console.log(term7.reducir().toString() == "true")