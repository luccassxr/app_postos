import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const WKClienteApp());

class C {
  static const bg = Color(0xFF010712);
  static const bg2 = Color(0xFF06142A);
  static const card = Color(0xFF081629);
  static const card2 = Color(0xFF0D1D34);
  static const blue = Color(0xFF1473FF);
  static const blue2 = Color(0xFF0A4FC8);
  static const red = Color(0xFFF3182C);
  static const green = Color(0xFF20D875);
  static const white = Color(0xFFF7F9FF);
  static const muted = Color(0xFF9EACC3);
  static const border = Color(0xFF263B5C);
}

class WKClienteApp extends StatelessWidget {
  const WKClienteApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WK Cliente',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: C.bg,
        colorScheme: const ColorScheme.dark(primary: C.blue, secondary: C.red, surface: C.card),
        textTheme: ThemeData.dark().textTheme.apply(bodyColor: C.white, displayColor: C.white),
        navigationBarTheme: const NavigationBarThemeData(backgroundColor: Color(0xFF030C1B), indicatorColor: Color(0xFF123B83), height: 72),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: C.card2,
          hintStyle: const TextStyle(color: C.muted),
          prefixIconColor: C.muted,
          suffixIconColor: C.muted,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: C.border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: C.blue, width: 1.5)),
        ),
      ),
      home: const SplashPage(),
    );
  }
}

class WKBackdrop extends StatelessWidget {
  final Widget child;
  const WKBackdrop({super.key, required this.child});
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      gradient: RadialGradient(center: Alignment(0, -0.48), radius: 1.15, colors: [Color(0xFF0A2E67), C.bg2, C.bg, Color(0xFF000309)], stops: [0, .34, .72, 1]),
    ),
    child: child,
  );
}

class WKLogo extends StatelessWidget {
  final double width;
  const WKLogo({super.key, this.width = 160});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        height: width * .44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width),
          border: Border.all(color: C.red, width: 4),
          boxShadow: [BoxShadow(color: C.blue.withOpacity(.22), blurRadius: 28, spreadRadius: 3)],
          gradient: const LinearGradient(colors: [Color(0xFF142C72), Color(0xFF142C72), C.red], stops: [0, .64, .64]),
        ),
        alignment: Alignment.center,
        child: Text('WK', style: TextStyle(fontSize: width * .28, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, color: Colors.white, letterSpacing: -4)),
      ),
      SizedBox(height: width * .06),
      Text('GRUPO WK', style: TextStyle(fontSize: width * .085, fontWeight: FontWeight.w900, letterSpacing: 1.4)),
    ]),
  );
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override State<SplashPage> createState() => _SplashPageState();
}
class _SplashPageState extends State<SplashPage> {
  @override void initState() { super.initState(); Timer(const Duration(milliseconds: 1900), () { if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage())); }); }
  @override Widget build(BuildContext context) => Scaffold(body: WKBackdrop(child: SafeArea(child: Column(children: [
    const Spacer(flex: 4),
    const WKLogo(width: 205),
    const SizedBox(height: 18),
    const Text('Confia no Senhor de todo\no seu coração!', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, height: 1.35)),
    const Spacer(flex: 4),
    const Text('Carregando', style: TextStyle(color: C.muted, fontSize: 15)),
    const SizedBox(height: 12),
    SizedBox(width: 190, child: ClipRRect(borderRadius: BorderRadius.circular(12), child: const LinearProgressIndicator(minHeight: 4, backgroundColor: C.border))),
    const SizedBox(height: 54),
  ]))));
}

class LoginPage extends StatefulWidget { const LoginPage({super.key}); @override State<LoginPage> createState() => _LoginPageState(); }
class _LoginPageState extends State<LoginPage> {
  bool hide = true;
  @override Widget build(BuildContext context) => Scaffold(body: WKBackdrop(child: SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(26, 30, 26, 32), children: [
    const Center(child: WKLogo(width: 165)),
    const SizedBox(height: 44),
    const Text('Acesse sua conta', style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900)),
    const SizedBox(height: 8),
    const Text('Entre para acompanhar seus pontos, benefícios e abastecimentos.', style: TextStyle(color: C.muted, fontSize: 16, height: 1.4)),
    const SizedBox(height: 28),
    WKCard(child: Column(children: [
      const TextField(decoration: InputDecoration(hintText: 'E-mail ou CPF', prefixIcon: Icon(Icons.person_outline_rounded))),
      const SizedBox(height: 14),
      TextField(obscureText: hide, decoration: InputDecoration(hintText: 'Senha', prefixIcon: const Icon(Icons.lock_outline_rounded), suffixIcon: IconButton(onPressed: () => setState(() => hide = !hide), icon: Icon(hide ? Icons.visibility_outlined : Icons.visibility_off_outlined)))),
      const SizedBox(height: 8),
      Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => toast(context, 'Recuperação de senha disponível na próxima etapa.'), child: const Text('Esqueci minha senha'))),
      const SizedBox(height: 4),
      PrimaryButton(label: 'ENTRAR', onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShell()))),
    ])),
    const SizedBox(height: 22),
    OutlinedButton.icon(onPressed: () => toast(context, 'Login Google será conectado ao Firebase.'), icon: const Icon(Icons.g_mobiledata_rounded, size: 30), label: const Text('Continuar com Google'), style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(56), side: const BorderSide(color: C.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)))),
    const SizedBox(height: 18),
    Center(child: TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())), child: const Text('Ainda não tem conta?  Criar cadastro'))),
  ]))));
}

class RegisterPage extends StatefulWidget { const RegisterPage({super.key}); @override State<RegisterPage> createState() => _RegisterPageState(); }
class _RegisterPageState extends State<RegisterPage> {
  bool accepted = false;
  @override Widget build(BuildContext context) => Scaffold(body: WKBackdrop(child: SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(24, 18, 24, 30), children: [
    Row(children: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)), const Spacer(), const WKLogo(width: 125), const Spacer(), const SizedBox(width: 48)]),
    const SizedBox(height: 20),
    const Text('Crie sua conta', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
    const SizedBox(height: 4), const Text('É rápido, fácil e grátis!', style: TextStyle(color: C.muted, fontSize: 16)),
    const SizedBox(height: 22),
    WKCard(child: Column(children: [
      for (final f in const [('Nome completo', Icons.person_outline), ('CPF', Icons.badge_outlined), ('Telefone', Icons.phone_outlined), ('E-mail', Icons.mail_outline), ('Senha', Icons.lock_outline), ('Confirmar senha', Icons.lock_outline)]) ...[
        TextField(obscureText: f.$1.toLowerCase().contains('senha'), decoration: InputDecoration(hintText: f.$1, prefixIcon: Icon(f.$2))), const SizedBox(height: 12)
      ],
      CheckboxListTile(value: accepted, onChanged: (v) => setState(() => accepted = v ?? false), contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading, title: const Text('Li e aceito os termos de uso e a política de privacidade.', style: TextStyle(fontSize: 13.5))),
      const SizedBox(height: 6),
      PrimaryButton(label: 'CRIAR CONTA', onTap: accepted ? () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainShell()), (_) => false) : null),
    ])),
  ]))));
}

class MainShell extends StatefulWidget { const MainShell({super.key}); @override State<MainShell> createState() => _MainShellState(); }
class _MainShellState extends State<MainShell> {
  int i = 0;
  final pages = const [HomePage(), StationsPage(), BenefitsPage(), ProfilePage()];
  @override Widget build(BuildContext context) => Scaffold(
    body: WKBackdrop(child: SafeArea(child: pages[i])),
    bottomNavigationBar: NavigationBar(selectedIndex: i, onDestinationSelected: (v) => setState(() => i = v), destinations: const [
      NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Início'),
      NavigationDestination(icon: Icon(Icons.local_gas_station_outlined), selectedIcon: Icon(Icons.local_gas_station_rounded), label: 'Postos'),
      NavigationDestination(icon: Icon(Icons.local_offer_outlined), selectedIcon: Icon(Icons.local_offer_rounded), label: 'Benefícios'),
      NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person_rounded), label: 'Perfil'),
    ]),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(20, 18, 20, 26), children: [
    const Row(children: [WKLogo(width: 122), Spacer(), CircleAvatar(radius: 23, backgroundColor: C.card2, child: Icon(Icons.notifications_none_rounded)), SizedBox(width: 9), CircleAvatar(radius: 23, backgroundColor: C.card2, child: Icon(Icons.person_outline_rounded))]),
    const SizedBox(height: 24),
    Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), border: Border.all(color: C.red.withOpacity(.75)), gradient: const LinearGradient(colors: [Color(0xFF0D347B), Color(0xFF071329)])), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Abasteça e ganhe pontos', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900)), SizedBox(height: 7), Text('Mais abastecimentos, mais vantagens para você!', style: TextStyle(color: C.muted, fontSize: 15.5))])),
    const SizedBox(height: 16),
    WKCard(child: Row(children: [const CircleAvatar(radius: 29, backgroundColor: Color(0xFF102E69), child: Icon(Icons.stars_rounded, color: C.blue, size: 34)), const SizedBox(width: 15), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Seus pontos', style: TextStyle(color: C.muted)), Text('1.250', style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900))])), TextButton(onPressed: () => showSheet(context, const PointsSheet()), child: const Text('Ver extrato'))])),
    const SizedBox(height: 16),
    WKCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Row(children: [Icon(Icons.location_on_rounded, color: C.blue), SizedBox(width: 7), Text('Posto mais próximo', style: TextStyle(color: C.blue, fontWeight: FontWeight.w800))]), const SizedBox(height: 8), const Text('Posto WK Ceres', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)), const Text('Ceres - GO • unidade de referência', style: TextStyle(color: C.muted)), const SizedBox(height: 14), PrimaryButton(label: 'VER ROTA', onTap: () => toast(context, 'Rota do Posto WK Ceres'))])),
    const SizedBox(height: 18),
    const Text('Combustíveis hoje', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)), const SizedBox(height: 10),
    const Row(children: [Expanded(child: FuelBox('GASOLINA', 'R\$ 5,69', C.red)), SizedBox(width: 8), Expanded(child: FuelBox('ETANOL', 'R\$ 3,89', C.green)), SizedBox(width: 8), Expanded(child: FuelBox('DIESEL S10', 'R\$ 5,89', C.blue))]),
    const SizedBox(height: 18),
    Row(children: [Expanded(child: Quick(icon: Icons.qr_code_2_rounded, label: 'Meu QR Code', onTap: () => showSheet(context, const QRSheet()))), const SizedBox(width: 10), Expanded(child: Quick(icon: Icons.local_offer_rounded, label: 'Promoções', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PromotionsPage()))))]),
  ]);
}

class FuelBox extends StatelessWidget { final String n,v; final Color c; const FuelBox(this.n,this.v,this.c,{super.key}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: C.card2, borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(.5))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(n, style: TextStyle(color:c, fontSize:11, fontWeight:FontWeight.w900)), const SizedBox(height:8), Text(v, style:const TextStyle(fontSize:17, fontWeight:FontWeight.w900)), const Text('/LITRO', style:TextStyle(color:C.muted,fontSize:10))])); }
class Quick extends StatelessWidget { final IconData icon; final String label; final VoidCallback onTap; const Quick({super.key,required this.icon,required this.label,required this.onTap}); @override Widget build(BuildContext context)=>InkWell(onTap:onTap,borderRadius:BorderRadius.circular(18),child:Container(padding:const EdgeInsets.symmetric(vertical:18,horizontal:12),decoration:BoxDecoration(color:C.card,borderRadius:BorderRadius.circular(18),border:Border.all(color:C.border)),child:Column(children:[Icon(icon,color:C.blue,size:30),const SizedBox(height:8),Text(label,style:const TextStyle(fontWeight:FontWeight.w800))]))); }

class BenefitsPage extends StatefulWidget { const BenefitsPage({super.key}); @override State<BenefitsPage> createState()=>_BenefitsPageState(); }
class _BenefitsPageState extends State<BenefitsPage> {
  final active=<int>{};
  @override Widget build(BuildContext context){ final data=[('10% OFF na lavagem','Desconto especial para deixar seu veículo impecável.','30/09/2026',Icons.local_car_wash_rounded),('Café grátis','Ganhe 1 café em abastecimentos acima de R\$ 80.','15/10/2026',Icons.coffee_rounded),('Troca de óleo com desconto','Condição exclusiva em serviços selecionados.','25/10/2026',Icons.oil_barrel_rounded)]; return ListView(padding:const EdgeInsets.fromLTRB(20,20,20,28),children:[
    const TitleBlock('Benefícios / Cupons','Promoções exclusivas para clientes WK.'), const SizedBox(height:18),
    Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFF12377D),Color(0xFF09172D)]),borderRadius:BorderRadius.circular(20),border:Border.all(color:C.blue.withOpacity(.45))),child:const Row(children:[Icon(Icons.stars_rounded,color:C.blue,size:34),SizedBox(width:14),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('1.250 pontos disponíveis',style:TextStyle(fontSize:20,fontWeight:FontWeight.w900)),Text('Use seus pontos e aproveite mais.',style:TextStyle(color:C.muted))]))])),
    const SizedBox(height:16),
    for(int x=0;x<data.length;x++) Padding(padding:const EdgeInsets.only(bottom:12),child:WKCard(child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[CircleAvatar(radius:27,backgroundColor:const Color(0xFF102E69),child:Icon(data[x].$4,color:C.blue)),const SizedBox(width:14),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(data[x].$1,style:const TextStyle(fontSize:18,fontWeight:FontWeight.w900)),const SizedBox(height:4),Text(data[x].$2,style:const TextStyle(color:C.muted,height:1.3)),const SizedBox(height:8),Text('Válido até ${data[x].$3}',style:const TextStyle(color:C.muted,fontSize:12)),const SizedBox(height:11),SizedBox(width:double.infinity,child:FilledButton(onPressed:()=>setState(()=>active.contains(x)?active.remove(x):active.add(x)),style:FilledButton.styleFrom(backgroundColor:active.contains(x)?C.green:C.blue,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(13))),child:Text(active.contains(x)?'CUPOM ATIVADO':'ATIVAR CUPOM',style:const TextStyle(fontWeight:FontWeight.w900)))]))])))),
  ]); }
}

class PromotionsPage extends StatelessWidget { const PromotionsPage({super.key}); @override Widget build(BuildContext context)=>Scaffold(body:WKBackdrop(child:SafeArea(child:ListView(padding:const EdgeInsets.all(20),children:[
  BackHeader(title:'Promoções'), const SizedBox(height:14), const Text('Ofertas nas unidades WK',style:TextStyle(fontSize:24,fontWeight:FontWeight.w900)),const SizedBox(height:5),const Text('Condições especiais em postos e lojas WK Acessórios.',style:TextStyle(color:C.muted)),const SizedBox(height:18),
  PromoCard(city:'Querência - MT',title:'WK Acessórios',offer:'Ofertas especiais em acessórios automotivos',icon:Icons.directions_car_filled_rounded),const SizedBox(height:12),
  PromoCard(city:'Rio Verde - GO',title:'WK Acessórios',offer:'Seleção de produtos com preços promocionais',icon:Icons.shopping_bag_rounded),const SizedBox(height:12),
  PromoCard(city:'Ceres - GO',title:'Posto WK Ceres',offer:'Benefícios exclusivos para clientes do programa WK',icon:Icons.local_gas_station_rounded),
])))); }
class PromoCard extends StatelessWidget { final String city,title,offer;final IconData icon;const PromoCard({super.key,required this.city,required this.title,required this.offer,required this.icon});@override Widget build(BuildContext context)=>WKCard(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[CircleAvatar(radius:26,backgroundColor:const Color(0xFF102E69),child:Icon(icon,color:C.blue)),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontSize:19,fontWeight:FontWeight.w900)),Text(city,style:const TextStyle(color:C.muted))]))]),const SizedBox(height:14),Text(offer,style:const TextStyle(fontSize:16,fontWeight:FontWeight.w700)),const SizedBox(height:14),PrimaryButton(label:'VER OFERTA',onTap:()=>toast(context,'Oferta demonstrativa do MVP'))])); }

class StationsPage extends StatelessWidget { const StationsPage({super.key}); @override Widget build(BuildContext context){ final d=[('Posto WK Ceres','Ceres - GO','0 km','Combustível • Conveniência'),('Posto WK Jaraguá','Jaraguá - GO','61 km','Combustível • Conveniência'),('Posto WK Anápolis','Anápolis - GO','141 km','Combustível • Serviços'),('Posto WK Rio Verde','Rio Verde - GO','407 km','Combustível • WK Acessórios'),('Posto WK Jataí','Jataí - GO','496 km','Combustível • Conveniência'),('Posto WK Querência','Querência - MT','577 km','Combustível • WK Acessórios')]; return ListView(padding:const EdgeInsets.fromLTRB(20,20,20,28),children:[const TitleBlock('Postos','Encontre uma unidade WK e veja os serviços disponíveis.'),const SizedBox(height:16),const TextField(decoration:InputDecoration(hintText:'Buscar posto ou cidade',prefixIcon:Icon(Icons.search_rounded))),const SizedBox(height:16),for(final p in d) Padding(padding:const EdgeInsets.only(bottom:11),child:WKCard(child:Row(children:[const CircleAvatar(radius:27,backgroundColor:Color(0xFF102E69),child:Icon(Icons.local_gas_station_rounded,color:C.blue)),const SizedBox(width:13),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(p.$1,style:const TextStyle(fontSize:17,fontWeight:FontWeight.w900)),Text(p.$2,style:const TextStyle(color:C.muted)),const SizedBox(height:5),Text(p.$4,style:const TextStyle(color:C.muted,fontSize:12))])),Column(crossAxisAlignment:CrossAxisAlignment.end,children:[Text(p.$3,style:const TextStyle(color:C.blue,fontWeight:FontWeight.w900)),IconButton(onPressed:()=>toast(context,'Abrindo rota para ${p.$1}'),icon:const Icon(Icons.arrow_forward_ios_rounded,size:17))])])))]); } }

class ProfilePage extends StatelessWidget { const ProfilePage({super.key}); @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.fromLTRB(20,20,20,28),children:[
  const TitleBlock('Perfil / Histórico','Sua conta e movimentações no programa WK.'),const SizedBox(height:18),
  WKCard(child:Row(children:[const CircleAvatar(radius:34,backgroundColor:Color(0xFF102E69),child:Icon(Icons.person_rounded,color:C.blue,size:36)),const SizedBox(width:14),const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Lucas Araújo',style:TextStyle(fontSize:21,fontWeight:FontWeight.w900)),Text('Cliente WK',style:TextStyle(color:C.blue,fontWeight:FontWeight.w700)),SizedBox(height:4),Text('Ceres - GO',style:TextStyle(color:C.muted))])),Column(crossAxisAlignment:CrossAxisAlignment.end,children:[const Text('1.250',style:TextStyle(fontSize:24,fontWeight:FontWeight.w900)),const Text('pontos',style:TextStyle(color:C.muted))])])),
  const SizedBox(height:14),
  const Row(children:[Expanded(child:StatBox('12','Abastecimentos')),SizedBox(width:10),Expanded(child:StatBox('3','Cupons usados')),SizedBox(width:10),Expanded(child:StatBox('1.250','Pontos'))]),
  const SizedBox(height:18), const Text('Histórico de abastecimentos',style:TextStyle(fontSize:19,fontWeight:FontWeight.w900)),const SizedBox(height:10),
  const HistoryItem('Posto WK Ceres','08/08/2026','R\$ 198,50','+198 pontos'),const HistoryItem('Posto WK Jaraguá','27/07/2026','R\$ 142,20','+142 pontos'),const HistoryItem('Posto WK Ceres','10/07/2026','R\$ 211,90','+211 pontos'),
  const SizedBox(height:16),OutlinedButton.icon(onPressed:()=>Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(_)=>const LoginPage()),(_)=>false),icon:const Icon(Icons.logout_rounded),label:const Text('Sair da conta')),
]); }
class StatBox extends StatelessWidget{final String n,l;const StatBox(this.n,this.l,{super.key});@override Widget build(BuildContext context)=>Container(padding:const EdgeInsets.symmetric(vertical:15,horizontal:8),decoration:BoxDecoration(color:C.card,borderRadius:BorderRadius.circular(16),border:Border.all(color:C.border)),child:Column(children:[Text(n,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w900)),const SizedBox(height:3),Text(l,textAlign:TextAlign.center,style:const TextStyle(color:C.muted,fontSize:11))]));}
class HistoryItem extends StatelessWidget{final String a,b,c,d;const HistoryItem(this.a,this.b,this.c,this.d,{super.key});@override Widget build(BuildContext context)=>Padding(padding:const EdgeInsets.only(bottom:10),child:WKCard(child:Row(children:[const Icon(Icons.local_gas_station_rounded,color:C.blue),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(a,style:const TextStyle(fontWeight:FontWeight.w800)),Text(b,style:const TextStyle(color:C.muted,fontSize:12))])),Column(crossAxisAlignment:CrossAxisAlignment.end,children:[Text(c,style:const TextStyle(fontWeight:FontWeight.w900)),Text(d,style:const TextStyle(color:C.green,fontWeight:FontWeight.w800,fontSize:12))])])));}

class QRSheet extends StatelessWidget { const QRSheet({super.key}); @override Widget build(BuildContext context)=>Sheet(child:Column(mainAxisSize:MainAxisSize.min,children:[const Text('Meu QR Code',style:TextStyle(fontSize:24,fontWeight:FontWeight.w900)),const SizedBox(height:6),const Text('Mostre este código ao frentista.',style:TextStyle(color:C.muted)),const SizedBox(height:22),Container(width:210,height:210,padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(22)),child:CustomPaint(painter:FakeQR())),const SizedBox(height:16),const Text('Lucas Araújo',style:TextStyle(fontSize:18,fontWeight:FontWeight.w900)),const Text('Cliente WK • 1.250 pontos',style:TextStyle(color:C.muted)),const SizedBox(height:24)])); }
class FakeQR extends CustomPainter { @override void paint(Canvas canvas,Size s){final p=Paint()..color=Colors.black;const n=17;final q=s.width/n;for(int y=0;y<n;y++)for(int x=0;x<n;x++){if(((x*7+y*11+x*y)%5<2)||((x<5&&y<5)||(x>11&&y<5)||(x<5&&y>11)))canvas.drawRect(Rect.fromLTWH(x*q,y*q,q*.92,q*.92),p);}}@override bool shouldRepaint(covariant CustomPainter oldDelegate)=>false; }
class PointsSheet extends StatelessWidget{const PointsSheet({super.key});@override Widget build(BuildContext context)=>const Sheet(child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Extrato de pontos',style:TextStyle(fontSize:24,fontWeight:FontWeight.w900)),SizedBox(height:18),HistoryItem('Posto WK Ceres','08/08/2026','Abastecimento','+198 pontos'),HistoryItem('Cupom utilizado','30/07/2026','Lavagem','-500 pontos'),HistoryItem('Posto WK Jaraguá','27/07/2026','Abastecimento','+142 pontos'),SizedBox(height:12)]));}
class Sheet extends StatelessWidget{final Widget child;const Sheet({super.key,required this.child});@override Widget build(BuildContext context)=>Container(padding:const EdgeInsets.fromLTRB(22,12,22,24),decoration:const BoxDecoration(color:C.card,borderRadius:BorderRadius.vertical(top:Radius.circular(28))),child:SafeArea(top:false,child:child));}

class WKCard extends StatelessWidget { final Widget child; const WKCard({super.key,required this.child}); @override Widget build(BuildContext context)=>Container(padding:const EdgeInsets.all(17),decoration:BoxDecoration(color:C.card.withOpacity(.94),borderRadius:BorderRadius.circular(20),border:Border.all(color:C.border.withOpacity(.82)),boxShadow:[BoxShadow(color:Colors.black.withOpacity(.2),blurRadius:18,offset:const Offset(0,8))]),child:child); }
class PrimaryButton extends StatelessWidget { final String label; final VoidCallback? onTap; const PrimaryButton({super.key,required this.label,required this.onTap}); @override Widget build(BuildContext context)=>SizedBox(width:double.infinity,height:54,child:FilledButton(onPressed:onTap,style:FilledButton.styleFrom(backgroundColor:C.blue,disabledBackgroundColor:C.border,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(15))),child:Text(label,style:const TextStyle(fontWeight:FontWeight.w900,letterSpacing:.35)))); }
class TitleBlock extends StatelessWidget{final String title,sub;const TitleBlock(this.title,this.sub,{super.key});@override Widget build(BuildContext context)=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontSize:29,fontWeight:FontWeight.w900)),const SizedBox(height:5),Text(sub,style:const TextStyle(color:C.muted,height:1.35))]);}
class BackHeader extends StatelessWidget{final String title;const BackHeader({super.key,required this.title});@override Widget build(BuildContext context)=>Row(children:[IconButton(onPressed:()=>Navigator.pop(context),icon:const Icon(Icons.arrow_back_rounded)),const SizedBox(width:6),Text(title,style:const TextStyle(fontSize:25,fontWeight:FontWeight.w900))]);}

void toast(BuildContext c,String s)=>ScaffoldMessenger.of(c).showSnackBar(SnackBar(content:Text(s),backgroundColor:C.card2));
void showSheet(BuildContext c,Widget w)=>showModalBottomSheet(context:c,isScrollControlled:true,backgroundColor:Colors.transparent,builder:(_)=>w);
