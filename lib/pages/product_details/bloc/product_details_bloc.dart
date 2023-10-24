import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/models/Product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  ProductDetailsBloc() : super(ProductDetailsInitial()) {
    on<GetProductDetailsEvent>(getProductDetailsEvent);
  }

  FutureOr<void> getProductDetailsEvent(GetProductDetailsEvent event, Emitter<ProductDetailsState> emit) async {
    emit(ProductDetailsLoadingState());

    Future fetchProductDetails() async {
      try {
        var response = await http.get(Uri.https('fakestoreapi.com', '/products/${event.productIndex}'));
        var jsonData = jsonDecode(response.body);

        Product formattedProduct = Product(
              id: jsonData['id'],
              title: jsonData['title'],
              price: jsonData['price'],
              rating: jsonData['rating'],
              description: jsonData['description'],
              category: jsonData['category'],
              image: jsonData['image']);

        // fetch user's wishlist
        final users = FirebaseFirestore.instance.collection('users');

        final docRef = users.doc(FirebaseAuth.instance.currentUser!.uid);

        /// send your request here
        // final bool success= await sendRequest();

        await docRef.get().then((DocumentSnapshot doc) {
          if (doc.exists) {
            final copiedData = doc.data() as Map<String, dynamic>;
            final List wishlist = copiedData['wishlist'];

        emit(ProductDetailsLoadedSuccessState(product: formattedProduct, wishlist: wishlist));
          }
        });
      } catch (e) {
        print(e);
      }

    }

    try {
      await fetchProductDetails();

    } catch (e) {

    }
  }
}
