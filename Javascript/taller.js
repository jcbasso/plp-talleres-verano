    Evaluador = {}
    Evaluador.evaluar = function(){
        if (this.hasOwnProperty("reducir")){
            return this.reducir().evaluar()
        }else{
            return this
        }             
    }

    casoBase = function(o){
        return o.caso_base
    }

    deepCopyT = function(o){
        var res = {}
        for (var k in o){
            if(o.hasOwnProperty(k)){
                if(!casoBase(o[k]) && (casoBase(o[k]) != undefined)){
                    res[k] = deepCopyT(o[k])
                }else{
                    res[k] = o[k]
                }
            }
        }
        return res
    }

    Evaluador.deepCopyT = function(){
        return deepCopyT(this)
    }


//Tipos
    //Bool
    Bool = {}
    Bool.toString = function(){return "Bool"}
    Bool.deepCopy = function(){return this}
    Bool.__
    Bool.caso_base = true

    //Flechaf
    Flecha = function(a,b){
        this.A = a
        this.B = b
        this.toString = function(){return "(" + this.A.toString() + " -> " + this.B.toString() + ")"} 
        this.deepCopy = function(){
            return new Flecha(this.A.deepCopy(),this.B.deepCopy())
        }

    }

//Terminos
    //TRUE
    TT = {}
    TT.toString = function(){return "true"}
    TT.deepCopy = function(){return this}
    TT.sust = function(x,m){return this}
    TT.caso_base = true
    TT.__proto__ = Evaluador
    //FALSE
    FF = {}
    FF.toString = function(){return "false"}
    FF.deepCopy = function(){return this}
    FF.sust = function(x,m){return this}
    FF.caso_base = true
    FF.__proto__ = Evaluador

    //VAR
    X = function(s){
        this.X = s
        this.toString = function(){return this.X}
        this.deepCopy = function(){return new X(this.X)}
        this.sust = function(x,m){
            if(this.X == x) res = m
            else res = this.X
            return res
        }
        this.caso_base = false
    }
    X.prototype = Evaluador

    //APP
    app = function(m,n){
        
        this.M = m
        this.N = n
        this.toString = function(){
            return "(" + this.M.toString() + " " + this.N.toString() + ")"    
        }

        this.deepCopy = function(){
            return new app(this.M.deepCopy(),this.N.deepCopy())
        }

        this.sust = function(x,m){
            return new app(this.M.sust(x,m),this.N.sust(x,m))
        }

        this.reducir = function(){
            if (this.M.hasOwnProperty('reducir')){ 
                this.M = this.M.reducir()
            }
            else if (this.N.hasOwnProperty('reducir')){
                this.N = this.N.reducir()
            }
            else {
                return this.M.M.sust(this.M.X, this.N) 
            }
            return this
        }
        this.caso_base = false

    }
    app.prototype = Evaluador

    //ABS
    abs = function(x,a,m){
        this.X = x
        this.A = a
        this.M = m

        this.toString = function(){
            return "\\" + this.X + ":" + this.A.toString() + "." + this.M.toString()
        }

        this.deepCopy = function(){
            return new abs(this.A.deepCopy(),this.M.deepCopy())
        }

        this.sust = function(y,m){
            if(y == this.X) res = this
            else res = new abs(this.X,this.A,this.M.sust(y,m))
            return res
        }

        this.caso_base = false
    }
    abs.prototype = Evaluador

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
m = new abs("z", Bool,z)
n = new app(new abs ("x",Bool,x), TT)
term7 = new app(m, n)
 
term8 = new app( new abs("z", Bool,z) , new app(new abs ("x",Bool,x), TT))
term9 = new app(x,TT )

// console.log("Tests toString() ej 2")
 console.log(Bool.toString() == "Bool")
 console.log(term3.toString() == "\\x:Bool.true")
 console.log(term.toString() == "\\x:((Bool -> Bool) -> Bool).(x true)")
 console.log(term2.toString() == "\\y:((Bool -> Bool) -> Bool).(x true)")

// console.log("Tests toString() ej 3")
 console.log(Bool.deepCopy() == Bool)
 console.log(x.deepCopy() != x.deepCopy)
 console.log(fB.deepCopy() != fB.deepCopy)
 console.log(term.deepCopy() != term)

 console.log("Tests sust(x,m) ej 4")
 console.log((TT.sust("x",TT)).toString() == "true")
 console.log((FF.sust("x",FF)).toString() == "false")
 console.log((x.sust("x",FF)).toString() == "false")
 console.log((x.sust("y",FF)).toString() == "x")
 console.log((term.sust("x",FF)).toString() == "\\x:((Bool -> Bool) -> Bool).(x true)")
 console.log((term3.sust("x",FF)).toString() == "\\x:Bool.true")
 console.log((term4.sust("y",FF)).toString() == "\\x:Bool.x")
 console.log((term5.sust("x",FF)).toString() == "\\y:Bool.false")
 console.log((term5.sust("x",new X("p"))).toString() == "\\y:Bool.p")
 console.log((term5.sust("x",term4)).toString() == "\\y:Bool.\\x:Bool.x")
 console.log(term.sust("x",FF).toString() == "\\x:((Bool -> Bool) -> Bool).(x true)")
 console.log(term2.sust("x",FF).toString() == "\\y:((Bool -> Bool) -> Bool).(false true)")
 console.log((term3.sust("x",FF)).toString() == "\\x:Bool.true")

 //prueba de reduccion
 console.log("Tests reducir() ej 5")
 console.log(term6.reducir().toString() == "true")
 console.log(term7.reducir().toString() == "(\\z:Bool.z true)")

//prueba evaluar
 console.log("Tests evaluar() ej 6")
 console.log(TT.evaluar().toString() == "true")
 console.log(term8.evaluar().toString()=="true")
 console.log(new app(m, FF).evaluar().toString() == "false")
 console.log(new app(TT, FF).toString() == "(true false)")

//Prueba deepCopy
console.log("Tests deepCopy() ej 7")
 term9_copiado = term9.deepCopyT()
 term9.M = z
 console.log(term9.toString() == "(z true)")
 console.log(term9_copiado.toString() == "(x true)")
