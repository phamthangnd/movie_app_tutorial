abstract class Mapper<N, M> {
  N from(M input);

  M? to(N input) {
    return null;
  }
}